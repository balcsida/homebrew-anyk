# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Homebrew tap (`balcsida/anyk`) that provides cask definitions for installing Hungarian Tax Authority (NAV) software on macOS. The main application is ÁNYK (AbevJava), a Java-based tax form filling application.

## Repository Structure

- `Casks/anyk.rb` - Main cask for the ÁNYK application (downloads, extracts, creates launcher script and macOS app bundle)
- `Casks/nav-igazol.rb` - Template cask for NAV certificate request forms (depends on anyk)

## Testing Casks Locally

```bash
# Install from local tap
brew install --cask ./Casks/anyk.rb

# Reinstall after changes
brew reinstall --cask ./Casks/anyk.rb

# Uninstall
brew uninstall --cask anyk

# Full cleanup including user data
brew uninstall --cask --zap anyk

# Audit cask for issues
brew audit --cask ./Casks/anyk.rb
```

## Architecture Notes

The `anyk` cask performs automated installation without the GUI wizard:
1. **preflight**: Extracts JAR contents, copies application files to `HOMEBREW_PREFIX/share/abevjava`, creates config file
2. **postflight**: Creates `anyk` launcher script in `HOMEBREW_PREFIX/bin` and macOS app bundle in `~/Applications/ÁNYK.app`

Template casks (like `nav-igazol`) depend on `anyk` and install form templates by invoking the template JAR installer.

## Key Paths

- Application files: `HOMEBREW_PREFIX/share/abevjava/`
- Config file: `HOMEBREW_PREFIX/etc/abevjavapath.cfg`
- Installer JAR (for templates): `HOMEBREW_PREFIX/share/anyk/abevjava_install.jar`
- User data: `~/abevjava/`
- User config: `~/.abevjava/<username>.enyk`

## Dependencies

All casks require Java 8 via `zulu@8` cask dependency.
