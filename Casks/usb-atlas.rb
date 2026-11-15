cask "usb-atlas" do
  version "0.1.2"
  sha256 "87690a66e3d75ac89d87ad833567de4c04998c1b468d290ebc454aaf0698fa7e"

  url "https://fermium.ltd.uk/apps/usb-atlas/releases/#{version}/USBAtlas-#{version}.dmg"
  name "USB Atlas"
  desc "Live map of everything plugged into your Mac over USB and Thunderbolt"
  homepage "https://fermium.ltd.uk/apps/usb-atlas/"

  livecheck do
    url "https://fermium.ltd.uk/apps/usb-atlas/latest.json"
    strategy :json do |json|
      json["version"]
    end
  end

  depends_on macos: :tahoe

  app "USB Atlas.app"

  # Not notarized yet: clear the quarantine flag so Gatekeeper lets the ad hoc signed app open.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/USB Atlas.app"],
        writable_paths: ["USB Atlas.app"],
        writable_base:  :appdir
  end

  uninstall quit: "com.fermium.usbatlas"

  # Settings and the window frame are the only things it saves.
  zap trash: "~/Library/Preferences/com.fermium.usbatlas.plist"

  caveats <<~EOS
    USB Atlas isn't notarized by Apple yet. This cask removes the
    quarantine flag after installing so the app opens normally.
  EOS
end
