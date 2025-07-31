const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();
const db = admin.firestore();

exports.checkLicense = functions.https.onRequest(async (req, res) => {
  if (req.method !== "POST") {
    return res.status(405).send("Yalnızca post işlemi geçerli.");
  }
  const {kullaniciAd} = req.body;
  try {
    const snapshot = await db.collection("license")
        .where("kullaniciAd", "==", kullaniciAd)
    // .where("sifre", "==", sifre)
    // .where("lisansNo", "==", lisansNo)
        .get();

    if (snapshot.empty) {
      res.status(401).json({
        status: "fail",
        message: "Lisans bulunamadı",
      });
    }
    const lisansList = snapshot.docs.map((doc) => doc.data());
    const now = new Date();
    const lisans = lisansList[0];
    const baslangic = new Date(lisans.baslangicTarih._seconds * 1000);
    const bitis = new Date(lisans.bitisTarih._seconds * 1000);

    if (!lisans.aktifMi) {
      res.status(403).json({
        status: "fail",
        message: "Lisans aktif değil",
        data: lisansList,
        count: lisansList.length,
      });
    }
    if (now < baslangic || now > bitis) {
      res.status(403).json({
        status: "fail",
        message: "Lisans süresi geçerli değil",
        data: lisansList,
        count: lisansList.length,
      });
    }
    if (lisans.mevcutHak >= lisans.kullanimHak) {
      res.status(403).json({
        status: "fail",
        message: "Kullanım hakkı dolmuş.",
        data: lisansList,
        count: lisansList.length,
      });
    }
    res.status(200).json({
      status: "success",
      message: "Kullanıcı aktif.", data: lisansList,
    });
  } catch (err) {
    res.status(500).json({message: "Sunucu hatası", err});
  }
});

// Post endpointi

exports.lisansEkle = functions.https.onRequest(async (req, res) => {
  if (req.method != "POST") {
    res.status(405).send("Yalnızca POST işlemi geçerlidir");
  }

  const {
    kullaniciAd,
    sifre,
    lisansNo,
    baslangicTarih,
    bitisTarih,
    kullanimHak,
    mevcutHak,
    aktifMi,
  } = req.body;

  if (!kullaniciAd ||
    !sifre ||
    !lisansNo ||
    !baslangicTarih ||
    !bitisTarih ||
    !kullanimHak
  ) {
    res.status(400).json({message: "Eksik alan bırakmayınız."});
  }

  try {
    await db.collection("license").add({
      kullaniciAd,
      sifre,
      lisansNo,
      baslangicTarih: new Date(baslangicTarih),
      bitisTarih: new Date(bitisTarih),
      aktifMi: aktifMi ?? true,
      kullanimHak,
      mevcutHak: mevcutHak ?? 0,
    });
    res.status(201).json({message: "Lisans Eklendi"});
  } catch (err) {
    res.status(500).json({message: "Sunucu Hatası", err});
  }
});

// Liste güncelleme işlemleri için

exports.lisansGuncelle = functions.https.onRequest(async (req, res) => {
  if (req.method != "PUT") {
    res.status(405).send("Yalnızca PUT işlemi geçerlidir");
  }
  const {kullaniciAd, aktifMi, baslangicTarih, bitisTarih} = req.body;

  if (!kullaniciAd) {
    res.status(400).json({message: "ID bilgisi eksik girilemez."});
  }

  try {
    const snapshot = await db.collection("license")
        .where("kullaniciAd", "==", kullaniciAd).get();

    if (snapshot.empty) {
      return res.status(404).json({message: "Kişi bulunamadı."});
    }
    const doc = snapshot.docs[0].ref;

    const guncelData = {};

    if (aktifMi !== undefined) {
      guncelData.aktifMi =
      aktifMi === true || aktifMi === "true";
    }
    if (baslangicTarih) {
      guncelData.baslangicTarih =
        admin.firestore.Timestamp.fromDate(new Date(baslangicTarih));
    }
    if (bitisTarih) {
      guncelData.bitisTarih =
        admin.firestore.Timestamp.fromDate(new Date(bitisTarih));
    }

    await doc.update(guncelData);
    return res.status(200).json(
        {
          message: "Belge güncellendi.",
          updatefield: guncelData,
        },
    );
  } catch (err) {
    console.error("Sunucu Hatası:", err);
    res.status(500).json({
      message: "Sunucu Hatası", error: String(err),
    });
  }
});

// Silme işlemi

exports.deleteLisans = functions.https.onRequest(async (req, res) => {
  if (req.method != "DELETE") {
    return res.status(405).json(
        {message: "Yalnızca DELETE işlemleri için geçerlidir."},
    );
  }
  const {kullaniciAd} = req.body;
  if (!kullaniciAd) {
    res.status(400).json(
        {message: "Kullanıcı olmadan olmadan lisans iptal edemezsiniz."},
    );
  }
  try {
    const snapshot = await db.collection("license")
        .where("kullaniciAd", "==", kullaniciAd).get();

    if (snapshot.empty) {
      res.status(404).json({message: "Kullanıcı bulunamadı."});
    }
    const doc = snapshot.docs[0];
    await db.collection("license").doc(doc.id).delete();

    res.status(200).json({
      status: "success",
      message: `${kullaniciAd} adlı kullanıcı silindi.`,
    });
  } catch (err) {
    res.status(500).json({message: "Sunucu Hatası"});
  }
});

// Tüm lisansları getirme

exports.tumLisanslar = functions.https.onRequest(async (req, res) => {
  if (req.method != "GET") {
    res.status(405).send("Yalnızca GET işlemi için geçerlidir.");
  }
  try {
    const veriler = await db.collection("license").get();
    if (veriler.empty) {
      res.status(404).json({message: "Lisans bulunamadı."});
    }

    const lisanList = veriler.docs.map((doc)=>({
      id: doc.id,
      ...doc.data(),
    }));
    res.status(200).json({
      message: "İşlem başarılı",
      data: lisanList,
    });
  } catch (err) {
    res.status(500).json({message: "Sunucu Hatası", err});
  }
});
