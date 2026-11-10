cask "bambuddy-cert-installer" do
  version "0.1.1"
  sha256 "e6d6c3d90e6b00cbe6db1275c8d3adccacbaa616ec71bcad2f7a72de97ca262f"

  url "https://github.com/fermium/bambuddy-cert-installer/releases/download/v#{version}/BambuddyCertInstaller-#{version}.zip"
  name "Bambuddy Cert Installer"
  desc "Menu bar app that adds Bambuddy's certificate to OrcaSlicer and Bambu Studio"
  homepage "https://github.com/fermium/bambuddy-cert-installer"

  livecheck do
    url :url
    strategy :github_latest
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
