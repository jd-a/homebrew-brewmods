class Vtracer < Formula
  desc "Raster to vector graphics converter built on top of visioncortex"
  homepage "https://github.com/visioncortex/vtracer"
  url "https://github.com/visioncortex/vtracer/archive/refs/tags/0.6.4.tar.gz"
  sha256 "a4b554afe0384ddbdb5f96dde2d2e6f412493ae990acc32e0d71c4f8b63d8ba4"
  license "MIT"

  depends_on "rust" => :build

  def install
    cd "cmdapp" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    system bin/"vtracer", "--version"
  end
end
