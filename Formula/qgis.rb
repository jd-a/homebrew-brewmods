class Qgis < Formula
  desc "User-friendly geographic information system (GIS)"
  homepage "https://qgis.org/"
  url "https://github.com/qgis/QGIS/archive/refs/tags/final-3_44_0.tar.gz"
  sha256 "33a44dc303d40820a263eaa5c20d7748f8996714fde6d08e59325a31a2f9a31a"
  license "GPL-2.0-only"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "qt@5"
  depends_on "python@3.13"
  depends_on "postgresql@17"
  depends_on "gdal"
  depends_on "proj"
  depends_on "geos"
  depends_on "grass"

  def install
    python = Formula["python@3.13"].opt_bin/"python3"
    args = std_cmake_args + %W[
      -DWITH_GRASS=ON
      -DGRASS_PREFIX=#{Formula["grass"].opt_prefix}
      -DPYTHON_EXECUTABLE=#{python}
      -DQGIS_MACAPP_BUNDLE=ON
      -DQGIS_ENABLE_TESTS=OFF
    ]

    mkdir "build" do
      system "cmake", "..", *args, "-GNinja"
      system "ninja", "install"
    end

    prefix.install "build/output/QGIS.app"
  end

  def caveats
    <<~EOS
      QGIS.app was installed to:
        #{opt_prefix}/QGIS.app

      To launch it:
        open #{opt_prefix}/QGIS.app

      To install in /Applications:
        mv #{opt_prefix}/QGIS.app /Applications/
    EOS
  end

  test do
    assert_predicate prefix/"QGIS.app", :exist?
    system "#{prefix}/QGIS.app/Contents/MacOS/QGIS", "--help"
  end
end
