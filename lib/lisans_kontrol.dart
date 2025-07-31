import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:licensecontrol/model/model.dart';
import 'package:licensecontrol/services/api_services.dart';
import 'package:licensecontrol/lisansekleme.dart';

class licenseControl extends StatefulWidget {
  const licenseControl({super.key});

  @override
  State<licenseControl> createState() => _licenseControlState();
}

class _licenseControlState extends State<licenseControl> {
  final TextEditingController adcontroller = TextEditingController();
  final TextEditingController durumcontroller = TextEditingController();
  final TextEditingController baslangiccontroller = TextEditingController();
  final TextEditingController bitiscontroller = TextEditingController();
  final TextEditingController kullinicicontreller = TextEditingController();

  final _controller = TextEditingController();
  String sonuc = '';
  List<LisansModel> _lisanslar = [];

  void _lisansKontrolEt() async {
    final kullaniciAd = _controller.text.trim();

    final result = await ApiServices.checklicense(kullaniciAd);
    setState(() {
      sonuc = result['message'] ?? 'Cevap alınamadı';
      _lisanslar = result['success'] ? result['data'] : [];
    });
  }

  void tumLisanslariGetir() async {
    final lisansListe = await ApiServices.tumLisanslar();
    setState(() {
      _lisanslar = lisansListe;
    });
  }

  void lisansGuncelle() async {
    final String kullaniciAd = adcontroller.text.trim();
    final String? durumtxt = durumcontroller.text.trim();
    final String? baslangicTarihtxt = baslangiccontroller.text.trim();
    final String? bitisTarihtxt = bitiscontroller.text.trim();

    bool? durum;
    DateTime? baslangicTarih;
    DateTime? bitisTarih;

    if (durumtxt != null && durumtxt.isNotEmpty) {
      if (durumtxt.toLowerCase() == 'true')
        durum = true;
      else if (durumtxt.toLowerCase() == 'false')
        durum = false;
    }

    if (baslangicTarihtxt != null && baslangicTarihtxt.isNotEmpty) {
      try {
        baslangicTarih = DateTime.parse(baslangicTarihtxt);
      } catch (e) {
        print("Geçersiz başlangıç tarihi");
      }
    }

    if (bitisTarihtxt != null && bitisTarihtxt.isNotEmpty) {
      try {
        bitisTarih = DateTime.parse(bitisTarihtxt);
      } catch (e) {
        print("Geçersiz bitiş tarihi");
      }
    }
    await ApiServices.updateLicense(
      kullaniciAd,
      durum,
      baslangicTarih,
      bitisTarih,
    );
  }

  void LisansSil() async {
    final kullaniciAd = kullinicicontreller.text.trim();
    await ApiServices.deleteLicense(kullaniciAd);
    tumLisanslariGetir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          showDialog(
            context: context,
            builder:
                (_) => AlertDialog(
                  backgroundColor: Colors.grey,
                  elevation: 15,
                  title: Text("Lisans Bilgi Güncelleme"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Card(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: TextField(
                                controller: adcontroller,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  labelText: 'Kullanıcı Adi',
                                  prefixIcon: Icon(
                                    Icons.person_2,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: durumcontroller,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  labelText: 'Durumu',
                                  prefixIcon: Icon(
                                    Icons.check,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: baslangiccontroller,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  labelText: 'Başlangıç Tarih',
                                  prefixIcon: Icon(
                                    Icons.calendar_month_outlined,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: TextField(
                                controller: bitiscontroller,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  labelText: 'Bitiş Tarihi',
                                  prefixIcon: Icon(
                                    Icons.calendar_month_outlined,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: TextField(
                            controller: kullinicicontreller,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              labelText: 'Kullanıcı Adı',
                              prefixIcon: Icon(
                                Icons.person_off,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              lisansGuncelle();
                              setState(() {
                                tumLisanslariGetir();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber,
                            ),
                            child: Text(
                              "Güncelle",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              LisansSil();
                              setState(() {
                                tumLisanslariGetir();
                              });
                              Navigator.pop(context);
                            },
                            child: Text(
                              "SİL",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
          );
        },
        child: Icon(Icons.update, color: Colors.white),
      ),
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(
          "Lisans Kontrol",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 27,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddLicense()),
              );
            },
            icon: Icon(
              Icons.dashboard_customize_rounded,
              color: Colors.white,
              size: 35,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  labelText: 'Kullanıcı Adı Giriniz',
                  labelStyle: TextStyle(color: Colors.black),
                  prefixIcon: Icon(Icons.person_outline, color: Colors.purple),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _lisansKontrolEt,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                elevation: 10,
              ),
              child: Text(
                "Lisans Sorgula",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            Text(sonuc),
            Expanded(
              child: ListView.builder(
                itemCount: _lisanslar.length,
                itemBuilder: (context, index) {
                  final lisans = _lisanslar[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.indigoAccent,
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              "Kullanıcı Adı: ${lisans.kullaniciAd}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Şifre: ${lisans.sifre}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "Durumu: ${lisans.aktifMi ? 'Aktif' : 'Pasif'}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "Başlama Tarihi: ${lisans.baslangicTarih.toString()}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                ),
                                Text(
                                  "Başlama Tarihi: ${lisans.bitisTarih.toString()}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 17,
                                  ),
                                ),
                                Text(
                                  "Alınan Kullanım Hakkı: ${lisans.kullanimHak} adet",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "Kalan Kullanım Hakkı: ${lisans.mevcutHak} adet",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "Lisans Numarası: ${lisans.lisansNo}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(17),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 12,
                ),
                onPressed: tumLisanslariGetir,
                child: Text(
                  "Tüm Lisanslar",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
