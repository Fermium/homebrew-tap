cask "bambuddy-cert-installer" do
  version "0.1.2"
  sha256 "d1a86fcefda53af6b582a4e70b5a373063b728f3b1ea8fee035acf3c162f2a96"

  url "https://fermium.ltd.uk/apps/bambuddy-cert-installer/releases/#{version}/BambuddyCertInstaller-#{version}.zip"
  name "Bambuddy Cert Installer"
  desc "Menu bar app that adds Bambuddy's certificate to OrcaSlicer and Bambu Studio"
  homepage "https://fermium.ltd.uk/apps/bambuddy-cert-installer/"

  livecheck do
    url "https://fermium.ltd.uk/apps/bambuddy-cert-installer/latest.json"
    strategy :json do |json|
      json["version"]
    end
  end

  depends_on macos: :sequoia

  app "Bambuddy Cert Installer.app"

  # Not notarized yet: clear the quarantine flag so Gatekeeper lets the ad hoc signed app open.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/Bambuddy Cert Installer.app"],
        writable_paths: ["Bambuddy Cert Installer.app"],
        writable_base:  :appdir
  end

  uninstall quit: "com.fermium.bambuddy-cert-installer"

  # The backups hold the slicers' original files: removing them means Undo can't put a slicer back.
  zap trash: [
    "~/Library/Application Support/Bambuddy Cert Installer",
    "~/Library/Preferences/com.fermium.bambuddy-cert-installer.plist",
  ]
end
