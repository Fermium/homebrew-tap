# Optional: the CLI alone, built from source. Most users should take the cask, which already
# links `peelgood` onto PATH. Requires the source repo to be public.
class Peelgood < Formula
  desc "Print any PDF, SVG or image as a thermal printer label (command-line)"
  homepage "https://github.com/fermium/peel-good-inc"
  url "https://github.com/Fermium/peel-good-inc/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "6b8ea146438b1678f41e1b140ea9cff198af64882cb396453fe0f195845fb42e"
  license "MIT"

  depends_on xcode: ["26.0", :build]
  depends_on macos: :sequoia

  conflicts_with cask: "peel-good-inc", because: "the cask already installs the peelgood binary"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "peelgood"
    bin.install ".build/release/peelgood"
  end

  test do
    system bin/"peelgood", "--list-sizes" # TODO: confirm this exits 0 on a Mac with no printers
  end
end
