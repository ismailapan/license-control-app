import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:licensecontrol/model/model.dart';
import 'package:licensecontrol/services/api_services.dart';

class AddLicense extends StatefulWidget {
  const AddLicense({super.key});

  @override
  State<AddLicense> createState() => _AddLicenseState();
}

class _AddLicenseState extends State<AddLicense> {
  final TextEditingController adcontroller = TextEditingController();
  final TextEditingController sifrecontroller = TextEditingController();
  final TextEditingController baslangiccontroller = TextEditingController();
  final TextEditingController bitiscontroller = TextEditingController();
  final TextEditingController lisansnocontroller = TextEditingController();
  final TextEditingController kullanimcontroller = TextEditingController();


 void AddLicense()async{
   final kullaniciAd = adcontroller.text.trim();
   final sifre = sifrecontroller.text.trim();
   final baslangicTarih = DateTime.parse(baslangiccontroller.text.trim());
   final bitisTarih = DateTime.parse(bitiscontroller.text.trim());
   final lisansno = int.tryParse(lisansnocontroller.text.trim());
   final kullanimHak = int.tryParse(kullanimcontroller.text.trim());
  
  final lisans = LisansModel(
    kullaniciAd: kullaniciAd, 
    sifre: sifre, 
    baslangicTarih: baslangicTarih, 
    bitisTarih: bitisTarih, 
    kullanimHak: kullanimHak ?? 0, 
    lisansNo: lisansno ?? 0,
    aktifMi: true,
    mevcutHak: 0 
    );
    final gidenData = await ApiServices.lisansEkle(lisans);
    if(gidenData['success']){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        backgroundColor: Colors.green,
        content: Text("Lisans başarılı bir şekilde eklendi.") ));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        backgroundColor: Colors.red,
        content: Text("İşlemde hata meydana geldi") ));
    }
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lisans Ekle",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: adcontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                  labelText: 'Kullanıcı Adı',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: sifrecontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                  labelText: 'Şifre',
                  prefixIcon: Icon(Icons.password_sharp),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: baslangiccontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                  labelText: 'Başlangıç Tarihi',
                  prefixIcon: Icon(Icons.calendar_month_outlined),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: bitiscontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                  labelText: 'Bitiş Tarihi',
                  prefixIcon: Icon(Icons.calendar_month_sharp),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: lisansnocontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                  labelText: 'Lisans No',
                  prefixIcon: Icon(Icons.document_scanner_outlined),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: kullanimcontroller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                  ),
                  labelText: 'Kullanım Hakkı',
                  prefixIcon: Icon(Icons.data_usage_rounded),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton.icon(
                onPressed: AddLicense, 
                style: ElevatedButton.styleFrom(elevation: 12),
                icon: Icon(Icons.note_add,color: Colors.black,),
                label: Text("Lisans Ekle",style: TextStyle(color: Colors.black),)),
            )
          ],
        ),
      ),
    );
  }
}