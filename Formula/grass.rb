class Grass < Formula
  desc "Geographic Resources Analysis Support System (GRASS GIS)"
  homepage "https://grass.osgeo.org/"
  url "https://grass.osgeo.org/grass84/source/grass-8.4.2.tar.gz"
  sha256 "066d5a612da8b00b9d62ea9e91022b8082b9a65b18549b4719078fd0cb26e142"
  license "GPL-2.0-or-later"
  revision 2

  depends_on "bison" => :build
  depends_on "flex" => :build
  depends_on "pkg-config" => :build

  depends_on "bzip2"
  depends_on "cairo"
  depends_on "fftw"
  depends_on "freetype"
  depends_on "gdal"
  depends_on "geos"
  depends_on "libomp"      # OpenMP runtime on macOS
  depends_on "libpng"
  depends_on "libsvm"
  depends_on "openblas"    # BLAS provider
  depends_on "pdal"
  depends_on "proj"
  depends_on "readline"
  depends_on "sqlite"
  depends_on "libtiff"
  depends_on "zstd"
  depends_on "zlib"

  # For PostgreSQL 18 instead, change this line to: depends_on "postgresql@18"
  depends_on "postgresql@17"  # provides libpq headers/libs too :contentReference[oaicite:5]{index=5}

  depends_on "python@3.14"

  def install
    # PDAL + friends: require C++17; enforce it explicitly.
    ENV.append "CXXFLAGS", "-std=c++17"
    ENV.append "CFLAGS", "-DGL_SILENCE_DEPRECATION"

    openblas = Formula["openblas"]
    libomp   = Formula["libomp"]
    pg       = Formula["postgresql@18"]

    args = %W[
      --prefix=#{prefix}
      --exec-prefix=#{prefix}

      --with-bzlib
      --with-bzlib-includes=#{Formula["bzip2"].opt_include}
      --with-bzlib-libs=#{Formula["bzip2"].opt_lib}

      --with-cairo
      --with-cairo-includes=#{Formula["cairo"].opt_include}/cairo
      --with-cairo-libs=#{Formula["cairo"].opt_lib}

      --with-fftw-includes=#{Formula["fftw"].opt_include}
      --with-fftw-libs=#{Formula["fftw"].opt_lib}

      --with-freetype
      --with-freetype-includes=#{Formula["freetype"].opt_include}/freetype2
      --with-freetype-libs=#{Formula["freetype"].opt_lib}

      --with-gdal=#{Formula["gdal"].opt_bin}/gdal-config
      --with-geos=#{Formula["geos"].opt_bin}/geos-config

      --with-libsvm=yes

      --with-openmp=yes
      --with-openmp-includes=#{libomp.opt_include}
      --with-openmp-libs=#{libomp.opt_lib}

      --with-blas=yes
      --with-blas-includes=#{openblas.opt_include}
      --with-blas-libs=#{openblas.opt_lib}

      --with-lapack=no

      --with-pdal=#{Formula["pdal"].opt_bin}/pdal-config

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

      --with-tiff-includes=#{Formula["libtiff"].opt_include}
      --with-tiff-libs=#{Formula["libtiff"].opt_lib}

      --with-zstd
      --with-zstd-includes=#{Formula["zstd"].opt_include}
      --with-zstd-libs=#{Formula["zstd"].opt_lib}

      --with-x=no
      --with-mysql=no
      --with-opencl=no
      --with-opengl=osx
    ]

    # Keep libLAS disabled (fragile/deprecated in many stacks); PDAL handles LAS well.
    args += ["--with-liblas=no"]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/grass --version")
  end
end
