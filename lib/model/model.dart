class LisansModel{
  final String kullaniciAd;
  final String sifre;
  final DateTime baslangicTarih;
  final DateTime bitisTarih;
  final int kullanimHak;
  final int mevcutHak;
  final int lisansNo;
  final bool aktifMi; 

  LisansModel({
    required this.kullaniciAd,
    required this.sifre,
    required this.baslangicTarih,
    required this.bitisTarih,
    required this.kullanimHak,
    required this.mevcutHak,
    required this.lisansNo,
    required this.aktifMi
  });

  factory LisansModel.fromjson(Map<String, dynamic>json){
    return LisansModel(
      kullaniciAd: json['kullaniciAd'] ?? '', 
      sifre: json['sifre'], 
      baslangicTarih: DateTime.fromMillisecondsSinceEpoch(json['baslangicTarih']['_seconds']*1000), 
      bitisTarih: DateTime.fromMillisecondsSinceEpoch(json['bitisTarih']['_seconds']*1000), 
      kullanimHak: json['kullanimHak'], 
      mevcutHak: json['mevcutHak'], 
      lisansNo: json['lisansNo'], 
      aktifMi: json['aktifMi']
      );
  }
}
