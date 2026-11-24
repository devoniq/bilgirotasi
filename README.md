# Bilgi Rotası

İlkokul, ortaokul ve lise öğrencileri için bilgi yarışması ve öğrenme uygulaması. Tek bir HTML sayfası ile iki JSON soru dosyasından oluşur; kurulum veya derleme gerektirmez.

## Özellikler

- **Üç seviye:** İlkokul (1–4), Ortaokul (5–8), Lise (9–12)
- **Yedi konu ve karışık mod:** Coğrafya, Tarih, Fen Bilimleri, Matematik, Spor, Sanat ve Edebiyat, Genel Kültür
- **Yarışma modu:** Öğrenci soru sayısını 5–15 arasında seçer. Her soru için süre sınırı, 3 can, bir 50:50 jokeri, art arda doğru cevaplara ek puan, yıldızlar ve her seçim için ayrı rekor vardır.
- **Öğretici geri bildirim:** Her cevaptan sonra kısa bir açıklama gösterilir. Oyun sonunda bütün sorular doğru cevaplarıyla birlikte listelenir.
- **Öğren kartları:** Süresiz, çevrilebilir bilgi kartları.
- **Öğretmen paneli:** Öğretmenler kendi sorularını ekleyip silebilir. Bu özellik yalnızca claude.ai üzerinde yayınlanan sürümde çalışır; aşağıya bakın.

## Dosyalar

| Dosya | İçerik |
| --- | --- |
| `index.html` | Uygulamanın tamamı (HTML, CSS, JavaScript) |
| `sorular.json` | Projeye özel hazırlanmış Türkçe soru bankası |
| `sorular-otdb.json` | Open Trivia Database'den Türkçeye uyarlanmış sorular |

## Çalıştırma

Sayfa soruları `fetch` ile okuduğu için dosyayı çift tıklayarak açmak yerine basit bir sunucu kullanın:

```bash
python -m http.server 8000
# Tarayıcıda: http://localhost:8000
```

**GitHub Pages ile yayın:** Depo ayarlarında *Settings → Pages → Deploy from a branch → main / (root)* seçeneğini işaretleyin.

## Soru ekleme

Her iki JSON dosyası da aynı biçimi kullanır:

```json
{
  "ilk":  { "cog": [ ... ], "tarih": [ ... ], "fen": [ ... ], "mat": [ ... ], "spor": [ ... ], "sanat": [ ... ], "gk": [ ... ] },
  "orta": { ... },
  "lise": { ... }
}
```

Her soru şu yapıdaki bir dizidir:

```json
["Soru metni", "Doğru cevap", ["Yanlış 1", "Yanlış 2", "Yanlış 3"], "Cevaptan sonra gösterilecek açıklama"]
```

Seviye anahtarları `ilk`, `orta` ve `lise`dir. Konu anahtarlarının karşılıkları şöyledir: `cog` Coğrafya, `tarih` Tarih, `fen` Fen Bilimleri, `mat` Matematik, `spor` Spor, `sanat` Sanat ve Edebiyat, `gk` Genel Kültür.

## Öğretmen paneli ve veritabanı

Öğretmen paneli, claude.ai artifact platformunun paylaşılan veritabanını (`sorular` koleksiyonu) kullanır. GitHub Pages'te ya da yerel sunucuda bu veritabanı bulunmadığından panel "bağlanılamıyor" mesajı gösterir. Uygulamanın geri kalanı JSON dosyalarıyla normal şekilde çalışır.

Kalıcı soruları depoya eklemek için JSON dosyalarını düzenleyip commit etmeniz yeterlidir.

## Lisans ve kaynaklar

- **Kod (`index.html`) ve `sorular.json`:** MIT lisansı (bkz. `LICENSE`)
- **`sorular-otdb.json`:** Sorular [Open Trivia Database](https://opentdb.com) (Pixeltail Games LLC) içeriğinden Türkçeye uyarlanmıştır ve [Creative Commons Atıf-AynıLisanslaPaylaş 4.0 (CC BY-SA 4.0)](https://creativecommons.org/licenses/by-sa/4.0/deed.tr) ile lisanslıdır. Uyarlama sırasında:
  - Soru metinleri Türkçeye çevrildi.
  - Yanlış seçenekler ve açıklamalar Türkiye bağlamına uygun olarak yeniden yazıldı (örneğin Edirne, Frigya ve Truva bağlantıları eklendi).
  - ABD merkezli, popüler kültüre dayalı ve doğru/yanlış biçimindeki sorular çıkarıldı.
  - Hatalı ya da güncelliğini yitirmiş bazı cevaplar düzeltildi.

Bu dosyayı kullanan veya değiştiren herkesin aynı lisansla paylaşması gerekir.
