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
  depends_on "python@3.13"

def install
  args = %W[
    --prefix=#{prefix}
    --with-cxx
    --with-python=#{Formula["python@3.13"].opt_bin}/python3
    --with-proj-share=#{Formula["proj"].opt_share}/proj
    --with-postgres-includes=#{Formula["postgresql@17"].opt_include}
    --with-postgres-libs=#{Formula["postgresql@17"].opt_lib}
    --with-postgres=yes
    --with-sqlite
    --enable-largefile
    --enable-shared
    --with-gdal=#{Formula["gdal"].opt_bin}/gdal-config
    --with-geos
  ]

  system "./configure", *args
  system "make", "-j#{ENV.make_jobs}"
  system "make", "install"
end


  test do
    system "#{bin}/grass", "--version"
  end
end
