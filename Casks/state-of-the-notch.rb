cask "state-of-the-notch" do
  version "0.1.0"
  sha256 "aed8cd7b96659a30b0164c220295ee6e26d90588e5db732d4df20b008bef6ccb"

  url "https://fermium.ltd.uk/apps/state-of-the-notch/releases/#{version}/StateOfTheNotch-#{version}.dmg"
  name "State of the Notch"
  desc "Live system stats in and around the MacBook notch"
  homepage "https://fermium.ltd.uk/apps/state-of-the-notch/"

  livecheck do
    url "https://fermium.ltd.uk/apps/state-of-the-notch/latest.json"
    strategy :json do |json|
      json["version"]
    end
  end

  depends_on macos: :tahoe

  app "State of the Notch.app"

  # Not notarized yet: clear the quarantine flag so Gatekeeper lets the ad hoc signed app open.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/State of the Notch.app"],
        writable_paths: ["State of the Notch.app"],
        writable_base:  :appdir
  end

  uninstall quit: "com.fermium.notchstats"

  # Settings are the only thing it saves. NotchStats is the folder older builds used.
  zap trash: [
    "~/Library/Application Support/NotchStats",
    "~/Library/Preferences/com.fermium.notchstats.plist",
  ]

  caveats <<~EOS
    State of the Notch isn't notarized by Apple yet. This cask removes the
    quarantine flag after installing so the app opens normally.
  EOS
end
