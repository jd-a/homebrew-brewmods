class CairoWithx < Formula
  desc "Vector graphics library with cross-device output support built with X11 support"
  homepage "https://cairographics.org/"
  url "https://cairographics.org/releases/cairo-1.16.0.tar.xz"
  sha256 "5e7b29b3f113ef870d1e3ecf8adf21f923396401604bda16d44be45e66052331"
  revision 2

  # bottle do
  #   sha256 "6a23a68837269a8410a54950fdc8883feda091f221118370f1bfd3adbf5ee89c" => :catalina
  #   sha256 "0984045234fb22fa3e54a337137e9e43a1bf997f5d77692ed02249dfdee2b1bf" => :mojave
  #   sha256 "5c383ad4625fb1bd15e44e99fba1201490fa478b26178abaca5abb0fdb51510e" => :high_sierra
  # end

  head do
    url "https://anongit.freedesktop.org/git/cairo", :using => :git
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  # depends_on :x11
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxt"
  depends_on "libxext"
  depends_on "libxrender"

  depends_on "fontconfig"
  depends_on "freetype"
  # depends_on "glib" # remove to solve issues compiling R, remove --enable-gobject=yes
  depends_on "libpng"
  depends_on "lzo"
  depends_on "pixman"

  uses_from_macos "zlib"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-svg=yes
      --enable-tee=yes
      --enable-quartz-image
      --enable-xcb=yes
      --enable-xlib=yes
      --enable-xlib-xrender=yes
    ]

    # if build.with? "x11"
    #   args << "--enable-xcb=yes" << "--enable-xlib=yes" << "--enable-xlib-xrender=yes"
    # else
    #   args << "--enable-xcb=no" << "--enable-xlib=no" << "--enable-xlib-xrender=no"
    # end

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <cairo.h>
      int main(int argc, char *argv[]) {
        cairo_surface_t *surface = cairo_image_surface_create(CAIRO_FORMAT_ARGB32, 600, 400);
        cairo_t *context = cairo_create(surface);
        return 0;
      }
    EOS
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    libpng = Formula["libpng"]
    pixman = Formula["pixman"]
    flags = %W[
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/cairo
      -I#{libpng.opt_include}/libpng16
      -I#{pixman.opt_include}/pixman-1
      -L#{lib}
      -lcairo
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
