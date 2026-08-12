# linux-whatsapp.web — Türkçe

Bu proje, **resmî WhatsApp Web** sayfasını Brave'in kurulu Web Uygulaması
(PWA) olarak Linux uygulama menüsünden güvenilir biçimde açmaya yarayan küçük,
incelenebilir bir yardımcıdır. Ayrıca sandbox içindeki Chromium uygulamalarında
klavyenin çalışmamasına yol açabilen eski/kayıp IBus soketini tanılar.

> **Bağımsız proje:** WhatsApp LLC, Meta Platforms, Inc. veya Brave Software,
> Inc. ile bağlantılı, onlarca onaylanmış ya da desteklenmiş resmî bir ürün
> değildir. WhatsApp ve Brave ilgili sahiplerinin markalarıdır. Proje WhatsApp
> veya Brave'i dağıtmaz ve değiştirmez.

## Yaptıkları

- Resmî Brave APT kurulumunu veya Brave Snap'i algılar.
- Kullanıcı yolu ya da sürüm numarası sabitlemeden WhatsApp Web PWA'yı bulur.
- Pencere sınıfı doğru olan uygulama menüsü kısayolunu oluşturur.
- Brave, profil, PWA, masaüstü girdisi ve IBus sağlığını denetler.
- Klavye sorunu için yalnız açık onayla kullanıcı IBus hizmetini yeniden başlatır.
- Kaldırırken yalnız kendi oluşturduğu dosyaları siler.

## Yapmadıkları

- Resmî olmayan istemci, sayfa değiştirme veya mesaj otomasyonu yoktur.
- QR tarama otomasyonu, veri kazıma ve DOM enjeksiyonu yoktur.
- Çerez, anahtar, profil, mesaj, IndexedDB veya oturum verisi kopyalamaz.
- Brave'i kurmaz, profilleri taşımaz ve kurulum sırasında IBus'u başlatmaz.

## Kurulum

Önce Brave'i [resmî Linux sayfasından](https://brave.com/linux/) kurun.

```bash
git clone https://github.com/KodOkullari/linux-whatsapp.web.git
cd linux-whatsapp.web
./install.sh
```

WhatsApp Web uygulaması henüz kurulu değilse araç yalnızca resmî adresi açar.
Brave'de **Kaydet ve paylaş → WhatsApp Web'i yükle** seçeneğini kullanın;
ardından terminale dönüp Enter'a basın. Ayrıntılar: [INSTALL.md](INSTALL.md).

Kurulum bitince uygulama menüsündeki **WhatsApp Web** simgesini kullanın.

Etiketli sürümlerde kurulabilir `.deb` paketi de bulunur:

```bash
sudo apt install ./linux-whatsapp-web_0.1.1_all.deb
linux-whatsapp-web setup
```

`.deb` yalnız programı ve belgeleri kurar; Brave'i açmaz, IBus'u yeniden
başlatmaz ve kullanıcı/tarayıcı profiline dokunmaz.

## Tanılama ve klavye onarımı

```bash
linux-whatsapp-web doctor
linux-whatsapp-web repair-input
```

İkinci komut yalnız bilgi verir, değişiklik yapmaz. Sorun gerçekten IBus ise,
önce yazılmamış metinleri kaydedin ve sonra:

```bash
linux-whatsapp-web repair-input --apply
```

Bu işlem yalnız mevcut kullanıcının IBus hizmetini yeniden başlatır; bazı açık
uygulamaları yeniden açmak gerekebilir. Ayrıntılar: [TROUBLESHOOTING.md](TROUBLESHOOTING.md).

## Kaldırma

```bash
./uninstall.sh
```

Brave, PWA, WhatsApp oturumu, sohbetler ve tarayıcı verileri silinmez. İsterseniz
PWA'yı ayrıca `brave://apps` sayfasından yönetebilirsiniz.

## Gizlilik ve kapsam

Yapılandırma yalnız Brave yolu, profil dizini adı/kökü ve herkese açık PWA
kimliğini içerir. Tanılama çıktısını paylaşmadan önce yine de yolları gözden
geçirin. Proje Ubuntu 24.04 GNOME/X11 ve Brave Snap üzerinde canlı sınanmıştır;
diğer masaüstleri için topluluk testleri gereklidir. WhatsApp ve Brave gelecekte
değişebileceği için sürekli uyumluluk garantisi verilemez.
