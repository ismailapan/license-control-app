import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:licensecontrol/model/model.dart';

class ApiServices {
  static String lisansKontrol = 'https://checklicense-opnlkf5noa-uc.a.run.app';

  static Future<Map<String, dynamic>> checklicense(String kullaniciAd) async {
    final url = Uri.parse(lisansKontrol);

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'kullaniciAd': kullaniciAd}),
      );

      final responsedata = jsonDecode(response.body);
      if (response.statusCode == 200) {
        List<LisansModel> lisanslar =
            (responsedata['data'] as List)
                .map((item) => LisansModel.fromjson(item))
                .toList();
                if(lisanslar.isNotEmpty&&lisanslar[0].aktifMi==false){
                  return{
                    'success':false,
                    'data':lisanslar,
                    'message':'Lisans aktif değil'
                  };
                }
        return {
          'success': true,
          'message': responsedata['message'],
          'data': lisanslar,
        };
        
      } else {
        return {
          'success': false,
          'message': 'Bu kullanıcıya ait lisans bulunamadı',
        };
      }
    } catch (e) {
      return {'message': 'Hata $e'};
    }
  }

  static String lisansKontrolbir =
      'https://tumlisanslar-opnlkf5noa-uc.a.run.app';
  static Future<List<LisansModel>> tumLisanslar() async {
    final uri = Uri.parse(lisansKontrolbir);
    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data['data'] as List<dynamic>;
        return list.map((item) => LisansModel.fromjson(item)).toList();
      } else {
        throw Exception('SUNUCU HATASI ${response.statusCode}');
      }
    } catch (err) {
      throw Exception('Veri alınamadı${err}');
    }
  }

  static String lisansEklemeKontrol =
      'https://lisansekle-opnlkf5noa-uc.a.run.app/';
  static Future<Map<String, dynamic>> lisansEkle(LisansModel lisans) async {
    final url = Uri.parse(lisansEklemeKontrol);
    try {
      final data = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'kullaniciAd': lisans.kullaniciAd,
          'sifre': lisans.sifre,
          'baslangicTarih': lisans.baslangicTarih.toIso8601String(),
          'bitisTarih': lisans.bitisTarih.toIso8601String(),
          'kullanimHak': lisans.kullanimHak,
          'aktifMi': lisans.aktifMi,
          'mevcutHak': lisans.mevcutHak,
          'lisansNo': lisans.lisansNo,
        }),
      );

      final response = jsonDecode(data.body);
      if (data.statusCode == 200) {
        return {
          'success': true,
          'message': response['message'] ?? 'Lisans Eklenemedi.',
        };
      } else {
        return {
          'success': false,
          'message': response['message'] ?? 'Cevap alınamadı.',
        };
      }
    } catch (err) {
      return {'success': false, 'message': 'Sunucu Hatası: $err'};
    }
  }

  static String lisansGuncellemeURL =
      'https://lisansguncelle-opnlkf5noa-uc.a.run.app';
  static Future<void> updateLicense(
    String kullaniciAd,
    bool? durum,
    DateTime? baslangicTarih,
    DateTime? bitisTarih,
  ) async {
    final uri = Uri.parse(lisansGuncellemeURL);
    try {
      final Map<String, dynamic> data = {'kullaniciAd': kullaniciAd};

      if (durum != null) data['aktifMi'] = durum;
      if (baslangicTarih != null)
        data['baslangicTarih'] = baslangicTarih.toIso8601String();
      if (bitisTarih != null) data['bitisTarih'] = bitisTarih.toIso8601String();

      final istenenGuncel = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (istenenGuncel.statusCode == 200) {
        print("Lisans güncellendi");
      } else {
        print("Sunucudan cevap alınamadı ${istenenGuncel.body}");
      }
    } catch (e) {
      print("Hata ${e}");
    }
  }
  static String lisansSilme = 'https://deletelisans-opnlkf5noa-uc.a.run.app';
  static Future<Map<String,dynamic>> deleteLicense(String kullaniciAd)async{
     final uri = Uri.parse(lisansSilme);
     try{
      final response = await http.delete(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'kullaniciAd':kullaniciAd
        })
      );
       final data = jsonDecode(response.body);

      if(response.statusCode==200){
        return{
          'success':true,
          'message': data['message'] ?? 'Lisans başarıyla silindi'
        };
      }
      else{
        return{
          'success':false,
          'message':data['message'] ?? 'Silme işlemi başarısız'
        };
      }
     }
     catch(e){
      return{
        'message':'Hata Oluştu $e'
      };
     }
  }
}