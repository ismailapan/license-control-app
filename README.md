# 🔐 License Control System

Bu proje, Flutter ile geliştirilen bir kullanıcı arayüzü (UI) ve Google Firebase + Node.js tabanlı bir backend API üzerinden çalışan bir **lisans kontrol ve yönetim sistemidir**.

## 🚀 Özellikler

- ✅ Lisans Ekleme (otomatik tarih ve hak ayarı)
- 📝 Lisans Güncelleme (aktiflik, başlangıç ve bitiş tarihleri)
- ❌ Lisans Silme (kullanıcı ID’sine göre)
- 🔍 Lisans Sorgulama (kullanıcı adına göre kontrol)
- ☁️ Firebase Firestore kullanımı
- 📡 RESTful API (Firebase Functions ile)
- 🧪 Postman test desteği
- 📱 Flutter UI ile dinamik veri gönderimi ve güncelleme

---

## 🛠️ Kullanılan Teknolojiler

| Katman | Teknoloji |
|-------|-----------|
| Backend | Node.js, Express, Firebase Functions |
| Veritabanı | Firebase Firestore |
| Frontend | Flutter |
| Diğer | HTTP, JSON, Git, GitHub |

---

## 🔧 Kurulum ve Başlatma

### 🔹 1. Firebase Backend
- Firebase Console üzerinden bir proje oluştur
- Firestore Database ve Functions etkinleştir
- `index.js` dosyasını `functions` klasörüne koy
- Terminalde:
  ```bash
  firebase deploy --only functions

