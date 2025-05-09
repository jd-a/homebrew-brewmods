class Vtracer < Formula
  desc "Raster to vector graphics converter built on top of visioncortex"
  homepage "https://github.com/visioncortex/vtracer"
  url "https://github.com/visioncortex/vtracer/archive/refs/tags/0.6.4.zip"
  sha256 "20010bd11eb56a1f72e77da12c1fc03401533048747a3dd13b13f4e67e93d596"
  license "MIT"

  depends_on "rust" => :build

  def install
    cd "cmdapp" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    system "#{bin}/vtracer", "--version"
  end
end
