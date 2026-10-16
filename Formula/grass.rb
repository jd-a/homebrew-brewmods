class Grass < Formula
  desc "Geographic Resources Analysis Support System (GRASS GIS)"
  homepage "https://grass.osgeo.org/"
  url "https://grass.osgeo.org/grass85/source/grass-8.5.0.tar.gz"
  sha256 "5d06c81504ea961fab709943cf41d8b3e27cdbaae7ccca5baf3f7bb0c5d9f33d"
  license "GPL-2.0-or-later"
  revision 1

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => :build

  depends_on "bzip2"
  depends_on "cairo"
  depends_on "fftw"
  depends_on "freetype"
  depends_on "gdal"
  depends_on "geos"
  depends_on "libomp"
  depends_on "libpng"
  depends_on "libpq@17"
  depends_on "libsvm"
  depends_on "libtiff"
  depends_on "openblas"
  depends_on "pdal"
  depends_on "proj"
  depends_on "python@3.15"
  depends_on "readline"
  depends_on "sqlite"
  depends_on "zlib"
  depends_on "zstd"

  def install
    # GRASS/PDAL C++ code requires C++17.
    ENV.append "CXXFLAGS", "-std=c++17"

    # Silence warnings from Apple's deprecated OpenGL implementation.
    ENV.append "CFLAGS", "-DGL_SILENCE_DEPRECATION"
    ENV.append "CXXFLAGS", "-DGL_SILENCE_DEPRECATION"

    libomp = Formula["libomp"]
    pg = Formula["libpq@17"]

    args = %W[
      --prefix=#{prefix}
      --exec-prefix=#{prefix}

      --with-bzlib
      --with-bzlib-includes=#{Formula["bzip2"].opt_include}
      --with-bzlib-libs=#{Formula["bzip2"].opt_lib}

      --with-cairo
      --with-cairo-includes=#{Formula["cairo"].opt_include}/cairo
      --with-cairo-libs=#{Formula["cairo"].opt_lib}

      --with-fftw
      --with-fftw-includes=#{Formula["fftw"].opt_include}
      --with-fftw-libs=#{Formula["fftw"].opt_lib}

      --with-freetype
      --with-freetype-includes=#{Formula["freetype"].opt_include}/freetype2
      --with-freetype-libs=#{Formula["freetype"].opt_lib}

      --with-gdal=#{Formula["gdal"].opt_bin}/gdal-config
      --with-geos=#{Formula["geos"].opt_bin}/geos-config

      --with-libpng=#{Formula["libpng"].opt_bin}/libpng-config

      --with-libsvm=yes

      --with-openmp=yes
      --with-openmp-includes=#{libomp.opt_include}
      --with-openmp-libs=#{libomp.opt_lib}

      --with-blas=openblas
      --with-lapack=openblas

      --with-pdal=yes

      --with-postgres=yes
      --with-postgres-includes=#{pg.opt_include}
      --with-postgres-libs=#{pg.opt_lib}

      --with-proj-includes=#{Formula["proj"].opt_include}
      --with-proj-libs=#{Formula["proj"].opt_lib}
      --with-proj-share=#{Formula["proj"].opt_share}/proj

      --with-pthread

      --with-readline
      --with-readline-includes=#{Formula["readline"].opt_include}
      --with-readline-libs=#{Formula["readline"].opt_lib}

      --with-sqlite
      --with-sqlite-includes=#{Formula["sqlite"].opt_include}
      --with-sqlite-libs=#{Formula["sqlite"].opt_lib}

      --with-tiff
      --with-tiff-includes=#{Formula["libtiff"].opt_include}
      --with-tiff-libs=#{Formula["libtiff"].opt_lib}

      --with-zstd
      --with-zstd-includes=#{Formula["zstd"].opt_include}
      --with-zstd-libs=#{Formula["zstd"].opt_lib}

      --with-liblas=no
      --with-mysql=no
      --with-opencl=no
      --with-opengl=aqua
      --with-x=no
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/grass --version")

    ENV["GRASS_CONFIG_DIR"] = testpath/".grass8"

    output = shell_output(
      "#{bin}/grass --tmp-project EPSG:4326 --exec g.proj -p",
    )

    assert_match "WGS 84", output
  end
end
