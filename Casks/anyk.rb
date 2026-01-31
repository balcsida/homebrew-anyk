cask "anyk" do
  version :latest
  sha256 :no_check

  url "https://nav.gov.hu/pfile/programFile?path=/nyomtatvanyok/letoltesek/nyomtatvanykitolto_programok/nyomtatvany_apeh/keretprogramok/AbevJava"
  name "ÁNYK"
  name "AbevJava"
  desc "Hungarian Tax Authority (NAV) form filling application"
  homepage "https://nav.gov.hu/nyomtatvanyok/letoltesek/nyomtatvanykitolto_programok/nyomtatvany_apeh/keretprogramok/AbevJava"

  depends_on cask: "temurin@8"

  installer manual: "abevjava_install.jar"

  binary "#{staged_path}/abevjava_install.jar", target: "#{HOMEBREW_PREFIX}/share/anyk/abevjava_install.jar"

  preflight do
    # Create necessary directories
    FileUtils.mkdir_p("#{HOMEBREW_PREFIX}/share/anyk")
    FileUtils.mkdir_p("#{Dir.home}/.abevjava")
    FileUtils.mkdir_p("#{Dir.home}/abevjava/eKuldes")
  end

  postflight do
    # Create launcher script
    launcher_script = "#{HOMEBREW_PREFIX}/bin/anyk"
    File.write(launcher_script, <<~EOS)
      #!/bin/bash
      # ÁNYK Launcher Script

      JAVA_HOME="$(/usr/libexec/java_home -v 1.8 2>/dev/null)"
      if [ -z "$JAVA_HOME" ]; then
        echo "Error: Java 8 is required. Install it with: brew install --cask temurin@8"
        exit 1
      fi

      ANYK_HOME="#{HOMEBREW_PREFIX}/share/anyk"
      ANYK_CONFIG="/usr/local/etc/abevjavapath.cfg"

      # Check if ÁNYK is installed
      if [ ! -f "$ANYK_CONFIG" ] || [ ! -d "$(cat "$ANYK_CONFIG" 2>/dev/null)" ]; then
        echo "ÁNYK is not installed. Running installer..."
        "$JAVA_HOME/bin/java" -jar "$ANYK_HOME/abevjava_install.jar"
      else
        INSTALL_DIR=$(cat "$ANYK_CONFIG")
        if [ -f "$INSTALL_DIR/abevjava_start.sh" ]; then
          cd "$INSTALL_DIR"
          exec ./abevjava_start.sh "$@"
        else
          echo "ÁNYK installation not found. Running installer..."
          "$JAVA_HOME/bin/java" -jar "$ANYK_HOME/abevjava_install.jar"
        fi
      fi
    EOS
    FileUtils.chmod(0755, launcher_script)

    # Create macOS app bundle
    app_path = "#{Dir.home}/Applications/ÁNYK.app"
    FileUtils.mkdir_p("#{app_path}/Contents/MacOS")
    FileUtils.mkdir_p("#{app_path}/Contents/Resources")

    # Create Info.plist
    File.write("#{app_path}/Contents/Info.plist", <<~EOS)
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleExecutable</key>
        <string>anyk</string>
        <key>CFBundleIconFile</key>
        <string>anyk</string>
        <key>CFBundleIdentifier</key>
        <string>hu.gov.nav.anyk</string>
        <key>CFBundleName</key>
        <string>ÁNYK</string>
        <key>CFBundlePackageType</key>
        <string>APPL</string>
        <key>CFBundleVersion</key>
        <string>1.0</string>
        <key>CFBundleShortVersionString</key>
        <string>1.0</string>
      </dict>
      </plist>
    EOS

    # Create executable
    File.write("#{app_path}/Contents/MacOS/anyk", <<~EOS)
      #!/bin/bash
      exec "#{HOMEBREW_PREFIX}/bin/anyk" "$@"
    EOS
    FileUtils.chmod(0755, "#{app_path}/Contents/MacOS/anyk")
  end

  uninstall delete: [
    "#{HOMEBREW_PREFIX}/bin/anyk",
    "#{HOMEBREW_PREFIX}/share/anyk",
    "#{Dir.home}/Applications/ÁNYK.app",
  ]

  zap trash: [
    "~/.abevjava",
    "~/abevjava",
    "/usr/local/etc/abevjavapath.cfg",
  ]

  caveats <<~EOS
    ÁNYK has been installed!

    To run ÁNYK:
      1. Open "ÁNYK" from ~/Applications, or
      2. Run `anyk` from the terminal

    On first run, the installer will guide you through setup.

    Recommended installation paths:
      - Program directory: /usr/local/share/abevjava
      - User data: ~/abevjava (default)
      - Electronic submission: ~/abevjava/eKuldes

    To install form templates (e.g., NAV_IGAZOL):
      brew install --cask nav-igazol
  EOS
end
