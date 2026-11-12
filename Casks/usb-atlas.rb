cask "usb-atlas" do
  version "0.1.1"
  sha256 "2b36c8c378624f770424002a5b99dffc75fe3e9323082fbae50d303753d77009"

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
