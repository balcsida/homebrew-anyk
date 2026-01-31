# Homebrew ÁNYK Tap

Homebrew tap for installing [ÁNYK (AbevJava)](https://nav.gov.hu/nyomtatvanyok/letoltesek/nyomtatvanykitolto_programok/nyomtatvany_apeh/keretprogramok/AbevJava) - the Hungarian Tax Authority (NAV) form filling application on macOS.

## Installation

First, add this tap:

```bash
brew tap balcsida/anyk
```

Then install ÁNYK:

```bash
brew install --cask anyk
```

## Usage

After installation, you can:

1. **Launch from Applications**: Open "ÁNYK" from `~/Applications`
2. **Launch from Terminal**: Run `anyk`

The installation is fully automated - no GUI wizard required.

### Data Locations

- **Program files**: `$(brew --prefix)/share/abevjava`
- **User data**: `~/abevjava`
- **Electronic submissions**: `~/abevjava/eKuldes`
- **User config**: `~/.abevjava/<username>.enyk`

## Form Templates

ÁNYK requires form templates to create tax forms. Templates are installed automatically without GUI interaction.

### Available Templates

| Cask | Description | Install Command |
|------|-------------|-----------------|
| `anyk-nav-igazol` | NAV certificate request form | `brew install --cask anyk-nav-igazol` |
| `anyk-08e` | NAV 08E form | `brew install --cask anyk-08e` |
| `anyk-24hipak` | NAV 24HIPAK form | `brew install --cask anyk-24hipak` |
| `anyk-2541` | NAV 2541 form | `brew install --cask anyk-2541` |
| `anyk-25hipak` | NAV 25HIPAK form | `brew install --cask anyk-25hipak` |
| `anyk-2658` | NAV 2658 form | `brew install --cask anyk-2658` |
| `anyk-26hipak` | NAV 26HIPAK form | `brew install --cask anyk-26hipak` |
| `anyk-26kisker` | NAV 26KISKER form | `brew install --cask anyk-26kisker` |
| `anyk-26ktbev` | NAV 26KTBEV form | `brew install --cask anyk-26ktbev` |
| `anyk-nav-j24` | NAV J24 form | `brew install --cask anyk-nav-j24` |
| `anyk-nav-j28` | NAV J28 form | `brew install --cask anyk-nav-j28` |
| `anyk-nav-j31` | NAV J31 form | `brew install --cask anyk-nav-j31` |
| `anyk-nav-j32` | NAV J32 form | `brew install --cask anyk-nav-j32` |

### Install Multiple Templates

```bash
brew install --cask anyk-nav-igazol anyk-24hipak anyk-nav-j28
```

## Requirements

- macOS 10.13 or later
- Java 21 (automatically installed via `temurin@21` dependency)

## Features

- **HiDPI/Retina display support** - Crisp rendering on high-resolution displays
- **Fully automated installation** - No GUI wizard required
- **Native ARM64 support** - Runs natively on Apple Silicon Macs

## Uninstallation

To remove ÁNYK:

```bash
brew uninstall --cask anyk
```

To also remove user data and configuration:

```bash
brew uninstall --cask --zap anyk
```

## Troubleshooting

### Java not found

If you get a Java error, ensure Java 21 is installed:

```bash
brew install --cask temurin@21
```

## License

This tap is provided as-is for convenience. ÁNYK is developed and maintained by the Hungarian Tax Authority (NAV).

## Links

- [ÁNYK Official Page](https://nav.gov.hu/nyomtatvanyok/letoltesek/nyomtatvanykitolto_programok/nyomtatvany_apeh/keretprogramok/AbevJava)
- [NAV Forms Portal](https://nav.gov.hu/nyomtatvanyok)
