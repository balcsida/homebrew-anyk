cask "nav-igazol" do
  version :latest
  sha256 :no_check

  url "https://nav.gov.hu/pfile/programFile?path=/nyomtatvanyok/letoltesek/nyomtatvanykitolto_programok/nyomtatvanykitolto_programok_nav/igazol/NAV_igazol"
  name "NAV IGAZOL Template"
  desc "NAV certificate request form template for ÁNYK"
  homepage "https://nav.gov.hu/nyomtatvanyok/letoltesek/nyomtatvanykitolto_programok/nyomtatvanykitolto_programok_nav/igazol"

  depends_on cask: "anyk"
  depends_on cask: "zulu@8"

  preflight do
    # Check if ÁNYK is installed
    config_file = "#{HOMEBREW_PREFIX}/etc/abevjavapath.cfg"
    unless File.exist?(config_file)
      odie "ÁNYK is not installed. Please run 'anyk' first to complete the installation."
    end
  end

  postflight do
    # Get ÁNYK installation directory
    config_file = "#{HOMEBREW_PREFIX}/etc/abevjavapath.cfg"
    anyk_dir = File.read(config_file).strip if File.exist?(config_file)

    if anyk_dir.nil? || anyk_dir.empty? || !Dir.exist?(anyk_dir)
      opoo "ÁNYK installation directory not found. Please run the template installer manually."
      opoo "Template JAR location: #{staged_path}/NAV_IGAZOL.jar"
    else
      # Run the template installer
      java_home = `"/usr/libexec/java_home" -v 1.8 2>/dev/null`.strip
      if java_home.empty?
        opoo "Java 8 not found. Please install the template manually."
      else
        system "#{java_home}/bin/java", "-jar", "#{staged_path}/NAV_IGAZOL.jar"
      end
    end
  end

  caveats <<~EOS
    NAV IGAZOL template has been installed!

    If the automatic installation didn't work:
      1. Open ÁNYK
      2. Go to Telepítések (Installations) menu
      3. Install the template from: #{staged_path}/NAV_IGAZOL.jar
  EOS
end
