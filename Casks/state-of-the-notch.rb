cask "state-of-the-notch" do
  version "0.2.1"
  sha256 "5625d97ecd522d3ae455b824d8932bd650f3856b8ebcd1cd33d25eaa8c7242db"

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

  auto_updates true
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
