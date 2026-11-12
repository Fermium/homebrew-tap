cask "bubucode" do
  version "0.1.4"
  sha256 "e37d50abe23e46d82a0513ae07a9c8bcccff9a12b6721e3aa9250bdb8f0f2b77"

  url "https://fermium.ltd.uk/apps/bubucode/releases/#{version}/BuBuCode-#{version}.dmg"
  name "BuBuCode"
  desc "Scan barcodes into any app with the Mac's own camera"
  homepage "https://fermium.ltd.uk/apps/bubucode/"

  livecheck do
    url "https://fermium.ltd.uk/apps/bubucode/latest.json"
    strategy :json do |json|
      json["version"]
    end
  end

  depends_on macos: :tahoe
  depends_on arch: :arm64

  app "BuBuCode.app"

  # Not notarized yet: clear the quarantine flag so Gatekeeper lets the ad hoc signed app open.
  postflight_steps do
    run "/usr/bin/xattr",
        args:           ["-dr", "com.apple.quarantine", "{{appdir}}/BuBuCode.app"],
        writable_paths: ["BuBuCode.app"],
        writable_base:  :appdir
  end

  uninstall quit:       "com.fermium.bubucode",
            login_item: "BuBuCode"

  zap trash: [
    "~/Library/Application Support/BuBuCode",
    "~/Library/Caches/com.fermium.bubucode",
    "~/Library/Preferences/com.fermium.bubucode.plist",
  ]

  caveats <<~EOS
    BuBuCode isn't notarized by Apple yet. This cask removes the
    quarantine flag after installing so the app opens normally.
  EOS
end
