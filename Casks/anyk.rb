cask "anyk" do
  version :latest
  sha256 :no_check

  url "https://nav.gov.hu/pfile/programFile?path=/nyomtatvanyok/letoltesek/nyomtatvanykitolto_programok/nyomtatvany_apeh/keretprogramok/AbevJava"
  name "ÁNYK"
  name "AbevJava"
  desc "Hungarian Tax Authority (NAV) form filling application"
  homepage "https://nav.gov.hu/nyomtatvanyok/letoltesek/nyomtatvanykitolto_programok/nyomtatvany_apeh/keretprogramok/AbevJava"

  depends_on cask: "temurin@8"

  # Keep the installer JAR for template installations
  artifact "abevjava_install.jar", target: "#{HOMEBREW_PREFIX}/share/anyk/abevjava_install.jar"

  preflight do
    # Create installation directories
    FileUtils.mkdir_p("#{HOMEBREW_PREFIX}/share/abevjava")
    FileUtils.mkdir_p("#{HOMEBREW_PREFIX}/etc")

    # Extract application files from installer JAR
    system_command "/usr/bin/unzip",
                   args: ["-o", "-q", "#{staged_path}/abevjava_install.jar", "application/*", "-d", staged_path.to_s]

    # Move application files to install directory
    Dir.glob("#{staged_path}/application/*").each do |f|
      FileUtils.cp_r(f, "#{HOMEBREW_PREFIX}/share/abevjava/")
    end

    # Extract macOS app bundle template and icon
    system_command "/usr/bin/unzip",
                   args: ["-o", "-q", "#{staged_path}/abevjava_install.jar", "os/install/mac/*", "-d", staged_path.to_s]

    # Create abevjavapath.cfg
    File.write("#{HOMEBREW_PREFIX}/etc/abevjavapath.cfg", "#{HOMEBREW_PREFIX}/share/abevjava")
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

      ANYK_HOME="#{HOMEBREW_PREFIX}/share/abevjava"
      ANYK_CONFIG="#{HOMEBREW_PREFIX}/etc/abevjavapath.cfg"
      USER_HOME="$HOME"
      USERNAME="$(whoami)"
      USER_CONFIG_DIR="$USER_HOME/.abevjava"
      USER_CONFIG="$USER_CONFIG_DIR/$USERNAME.enyk"
      USER_DATA_DIR="$USER_HOME/abevjava"

      # Create user directories if they don't exist
      mkdir -p "$USER_CONFIG_DIR"
      mkdir -p "$USER_DATA_DIR/eKuldes"

      # Create user config if it doesn't exist
      if [ ! -f "$USER_CONFIG" ]; then
        cat > "$USER_CONFIG" << ENYK
prop.usr.naplo=$USER_DATA_DIR/naplo
prop.usr.root=$USER_DATA_DIR
prop.usr.frissitesek=$USER_DATA_DIR/frissitesek
prop.usr.primaryaccounts=$USER_DATA_DIR/torzsadatok
ENYK
      fi

      # Set KRDIR environment variable for electronic submission
      export KRDIR="$USER_DATA_DIR/eKuldes"

      # Run ÁNYK
      cd "$ANYK_HOME"
      exec "$JAVA_HOME/bin/java" -jar "$ANYK_HOME/boot.jar" "useroptionfile=$USER_CONFIG"
    EOS
    FileUtils.chmod(0755, launcher_script)

    # Create macOS app bundle in ~/Applications
    app_path = "#{Dir.home}/Applications/ÁNYK.app"
    FileUtils.mkdir_p("#{app_path}/Contents/MacOS")
    FileUtils.mkdir_p("#{app_path}/Contents/Resources")

    # Copy icon from extracted files
    icon_src = "#{staged_path}/os/install/mac/abevjava.app/Contents/Resources/abevjava.icns"
    if File.exist?(icon_src)
      FileUtils.cp(icon_src, "#{app_path}/Contents/Resources/anyk.icns")
    end

    # Create Info.plist
    File.write("#{app_path}/Contents/Info.plist", <<~EOS)
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleDevelopmentRegion</key>
        <string>Hungarian</string>
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
        <key>NSHighResolutionCapable</key>
        <true/>
      </dict>
      </plist>
    EOS

    # Create executable wrapper
    File.write("#{app_path}/Contents/MacOS/anyk", <<~EOS)
      #!/bin/bash
      exec "#{HOMEBREW_PREFIX}/bin/anyk" "$@"
    EOS
    FileUtils.chmod(0755, "#{app_path}/Contents/MacOS/anyk")
  end

  uninstall delete: [
    "#{HOMEBREW_PREFIX}/bin/anyk",
    "#{HOMEBREW_PREFIX}/share/anyk",
    "#{HOMEBREW_PREFIX}/share/abevjava",
    "#{HOMEBREW_PREFIX}/etc/abevjavapath.cfg",
    "#{Dir.home}/Applications/ÁNYK.app",
  ]

  zap trash: [
    "~/.abevjava",
    "~/abevjava",
  ]

  caveats <<~EOS
    ÁNYK has been installed automatically!

    To run ÁNYK:
      1. Open "ÁNYK" from ~/Applications, or
      2. Run `anyk` from the terminal

    User data is stored in: ~/abevjava
    Electronic submissions: ~/abevjava/eKuldes

    To install form templates (e.g., NAV_IGAZOL):
      brew install --cask nav-igazol
  EOS
end
