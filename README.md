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

On first run, the installer will guide you through the setup process.

### Recommended Installation Paths

When the installer asks for paths, use:

- **Program directory**: `/usr/local/share/abevjava`
- **User data directory**: `~/abevjava` (default)
- **Electronic submission**: `~/abevjava/eKuldes`

## Form Templates

ÁNYK requires form templates to create tax forms. Install them separately:

### NAV IGAZOL (Certificate Request)

```bash
brew install --cask nav-igazol
```

## Requirements

- macOS 10.13 or later
- Java 8 (automatically installed via `temurin@8` dependency)

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

If you get a Java error, ensure Java 8 is installed:

```bash
brew install --cask temurin@8
```

### Display issues

If you experience display rendering issues, try setting these Java options:

```bash
export _JAVA_OPTIONS="-Dsun.java2d.xrender=false"
anyk
```

## License

This tap is provided as-is for convenience. ÁNYK is developed and maintained by the Hungarian Tax Authority (NAV).

## Links

- [ÁNYK Official Page](https://nav.gov.hu/nyomtatvanyok/letoltesek/nyomtatvanykitolto_programok/nyomtatvany_apeh/keretprogramok/AbevJava)
- [NAV Forms Portal](https://nav.gov.hu/nyomtatvanyok)
