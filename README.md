# Dershane Yönetim Uygulaması

Flutter ile yazılmış, masaüstünde çalışan dershane öğrenci ve ödeme takip uygulaması.

## Mimari

Clean Architecture + BLoC, feature-first klasörleme:

```
lib/
  core/       -> tema, DI, veritabanı, ortak sabitler/hatalar/usecase kontratı
  features/
    students/ -> data / domain / presentation katmanları
    payments/ -> data / domain / presentation katmanları
    dashboard/-> özet panosu
  shared/     -> sidebar, ortak widget'lar
```

## Kurulum

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # drift kod üretimi (app_database.g.dart)
flutter run -d windows   # veya -d macos / -d linux
```

`build_runner` komutu `core/database/app_database.g.dart` dosyasını üretir;
bu dosya repo'da yoktur, ilk kurulumda mutlaka çalıştırılmalı.

## Veri Modeli

- **Students**: id, firstName, lastName, phoneNumber, classLevel (sabit enum), createdAt
- **Payments**: id, studentId (FK), amount, period (örn. "Ocak 2026"), dueDate, paidDate, status (paid/unpaid/upcoming), createdAt

Sınıf seviyeleri `lib/core/enums/class_level.dart` içinde sabit bir liste
olarak tanımlı — ihtiyaç değişirse tek yerden güncellenir.

## Sırada ne var

- [ ] Dashboard'a gerçek istatistik kartları (toplam öğrenci, bu ay tahsilat vb.)
- [ ] Öğrenci detay sayfası + o öğrencinin ödeme geçmişi
- [ ] Ödeme ekleme formu (şu an sadece usecase/bloc hazır, dialog eklenecek)
- [ ] Arama / filtreleme (sınıf seviyesine göre, ödeme durumuna göre)
- [ ] Aylık toplu ödeme kaydı oluşturma (her öğrenci için otomatik "upcoming" satırı)
