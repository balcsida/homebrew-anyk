# Homebrew ÁNYK Tap

Homebrew tap az [ÁNYK (AbevJava)](https://nav.gov.hu/nyomtatvanyok/letoltesek/nyomtatvanykitolto_programok/nyomtatvany_apeh/keretprogramok/AbevJava) telepítéséhez macOS-en - a Nemzeti Adó- és Vámhivatal (NAV) nyomtatványkitöltő programja.

![ÁNYK macOS-en](images/screenshot.jpeg)

## Telepítés

### 1. lehetőség: Önálló alkalmazás (Homebrew nélkül)

Töltsd le az **univerzális** `.app` csomagot a [Releases](https://github.com/balcsida/homebrew-anyk/releases) oldalról:

- **Univerzális (Intel + Apple Silicon)**: `ANYK-vX.X.X-universal.dmg`

Az önálló alkalmazás Intel és Apple Silicon Mac gépeken is működik, tartalmazza a Java 21 futtatókörnyezetet és az összes NAV nyomtatványsablont - nincs szükség további szoftverekre.

**Telepítés:**
1. Töltsd le a DMG fájlt
2. Nyisd meg a DMG fájlt
3. Húzd az ÁNYK-t az Applications mappába
4. Jobb klikk → "Megnyitás" (csak első alkalommal, a Gatekeeper megkerüléséhez)

### 2. lehetőség: Homebrew

Először add hozzá a tap-et:

```bash
brew tap balcsida/anyk
```

Ezután telepítsd az ÁNYK-t:

```bash
brew install --cask anyk
```

## Használat

Telepítés után:

1. **Indítás az Alkalmazásokból**: Nyisd meg az "ÁNYK"-t a `~/Applications` mappából
2. **Indítás Terminálból**: Futtasd az `anyk` parancsot

A telepítés teljesen automatizált - nincs szükség GUI varázslóra.

### Adatok helye

- **Programfájlok**: `$(brew --prefix)/share/abevjava`
- **Felhasználói adatok**: `~/abevjava`
- **Elektronikus beküldések**: `~/abevjava/eKuldes`
- **Felhasználói konfiguráció**: `~/.abevjava/<felhasználónév>.enyk`

## Nyomtatványsablonok

Az ÁNYK nyomtatványsablonokat igényel az űrlapok létrehozásához. A sablonok automatikusan települnek, GUI interakció nélkül.

### Elérhető sablonok

**Több mint 550 NAV nyomtatványsablon érhető el!** A sablonok automatikusan generálódnak a NAV API-ból.

Sablon telepítése (a nyomtatvány azonosítójával):

```bash
brew install --cask anyk-25szja      # SZJA bevallás
brew install --cask anyk-2658        # Járulék bevallás
brew install --cask anyk-26hipak     # Helyi iparűzési adó
brew install --cask anyk-igazol      # NAV igazolás kérelem
```

### Sablonok keresése

Az összes elérhető sablon listázása:

```bash
brew search balcsida/anyk/anyk-
```

### Több sablon telepítése egyszerre

```bash
brew install --cask anyk-25szja anyk-2658 anyk-igazol
```

## Követelmények

- macOS 10.13 vagy újabb
- Java 21 (automatikusan települ a `temurin@21` függőségként)

## Funkciók

- **HiDPI/Retina kijelző támogatás** - Éles megjelenítés nagy felbontású kijelzőkön
- **Teljesen automatizált telepítés** - Nincs szükség GUI varázslóra
- **Natív ARM64 támogatás** - Natívan fut Apple Silicon Mac gépeken

## Eltávolítás

Az ÁNYK eltávolítása:

```bash
brew uninstall --cask anyk
```

Felhasználói adatok és konfiguráció eltávolítása is:

```bash
brew uninstall --cask --zap anyk
```

## Licenc

Ez a macOS felhasználók kényelméért készült, minden jog az eredeti jogtulajdonosoké.
Az ÁNYK-t a Nemzeti Adó- és Vámhivatal (NAV) fejleszti és tartja karban.

## Linkek

- [ÁNYK hivatalos oldal](https://nav.gov.hu/nyomtatvanyok/letoltesek/nyomtatvanykitolto_programok/nyomtatvany_apeh/keretprogramok/AbevJava)
- [NAV Nyomtatványok portál](https://nav.gov.hu/nyomtatvanyok)
