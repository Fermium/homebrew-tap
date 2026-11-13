cask "fill-light" do
  version "0.1.0"
  sha256 "58ca9f3ea42128eb608491b50833312058235dd5376af9244751ef707dda54e8"

  url "https://fermium.ltd.uk/apps/fill-light/releases/#{version}/FillLight-#{version}.dmg"
  name "Fill Light"
  desc "Light your face on video calls with the edges of the screen"
  homepage "https://fermium.ltd.uk/apps/fill-light/"

  livecheck do
    url "https://fermium.ltd.uk/apps/fill-light/latest.json"
    strategy :json do |json|
      json["version"]
    end
  end

  depends_on macos: :tahoe
  depends_on arch: :arm64

  app "Fill Light.app"

  # Not notarized yet: clear the quarantine flag so Gatekeeper lets the ad hoc signed app open.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/Fill Light.app"],
        writable_paths: ["Fill Light.app"],
        writable_base:  :appdir
  end

  uninstall quit:       "com.fermium.filllight",
            login_item: "Fill Light"

  zap trash: [
    "~/Library/Application Support/Fill Light",
    "~/Library/Caches/com.fermium.filllight",
    "~/Library/Preferences/com.fermium.filllight.plist",
  ]

  caveats <<~EOS
    Fill Light isn't notarized by Apple yet. This cask removes the
    quarantine flag after installing so the app opens normally.
  EOS
end
