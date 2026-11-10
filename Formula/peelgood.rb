# Optional: the CLI alone, built from source. Most users should take the cask, which already
# links `peelgood` onto PATH. Requires the source repo to be public.
class Peelgood < Formula
  desc "Print any PDF, SVG or image as a thermal printer label (command-line)"
  homepage "https://github.com/fermium/peel-good-inc"
  url "https://github.com/Fermium/peel-good-inc/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "ce4ef794d0c83ede7ee32050684f7405d58509035515f30ae1b37bf887e2abb5"
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
