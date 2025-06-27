class Grass < Formula
  desc "Geographic Resources Analysis Support System"
  homepage "https://grass.osgeo.org"
  url "https://github.com/OSGeo/grass/releases/download/8.4.1/grass-8.4.1.tar.gz"
  sha256 "d17dcf67e7c9bcd7103d53f4ba46a9d88430d84c6ce1350650b7021d62db0864"
  license "GPL-2.0-or-later"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "gdal"
  depends_on "proj"
  depends_on "postgresql@17"
  depends_on "wxmac" # for GUI
  depends_on "python@3.13"

  def install
    args = std_cmake_args + %W[
      -DENABLE_GUI=ON
      -DWITH_PYTHON=ON
      -DWITH_POSTGRES=ON
    ]
    mkdir "build" do
      system "cmake", "..", *args, "-GNinja"
      system "ninja", "install"
    end
  end

  test do
    system "#{bin}/grass", "--version"
  end
end
