class RExtendedcapabilities < Formula
  desc "Software environment for statistical computing with extended capabilities"
  homepage "https://www.r-project.org/"
  url "http://cran.r-project.org/src/base/R-3/R-3.6.3.tar.gz"
  sha256 "bd65a45cddfb88f37370fbcee4ac8dd3f1aebeebe47c2f968fd9770ba2bbc954"

  depends_on :x11 # X11 for Tcl-Tk
  depends_on "pkg-config" => :build
  depends_on "gcc" # for gfortran
  depends_on "gettext"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pcre"
  depends_on "readline"
  depends_on "xz"
  depends_on "openblas"
  depends_on "texinfo"
  depends_on "icu4c"
  depends_on "texinfo"
  depends_on "cairo-withx" # Cairo with X11 support
  depends_on "pango" => :optional
  depends_on :java => :optional

  # needed to preserve executable permissions on files without shebangs
  skip_clean "lib/R/bin"

  resource "gss" do
    url "https://cloud.r-project.org/src/contrib/gss_2.1-9.tar.gz", :using => :nounzip
    mirror "https://mirror.las.iastate.edu/CRAN/src/contrib/gss_2.1-9.tar.gz"
    sha256 "2961fe61c1d3bb3fe7b8e1070d6fb1dfc5d71e0c6e8a6b7c46ff6b42867c4cf3"
  end

  def install
    # Fix dyld: lazy symbol binding failed: Symbol not found: _clock_gettime
    if MacOS.version == "10.11" && MacOS::Xcode.installed? &&
       MacOS::Xcode.version >= "8.0"
      ENV["ac_cv_have_decl_clock_gettime"] = "no"
    end

    args = [
      "--prefix=#{prefix}",
      "--enable-memory-profiling",
      "--with-x", # X11 support, necessary for Tcl-Tk support
      "--with-aqua",
      "--with-lapack",
      "--enable-R-shlib",
      "SED=/usr/bin/sed", # don't remember Homebrew's sed shim
      "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas",
      "--with-tcltk", # Tcl-Tk support
      "--with-tcl-config=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/Tcl.framework/tclConfig.sh", # Point to the location of Tk, needs the Xcode command line tools and modification of TCL_INCLUDE_SPEC within the script
      "--with-tk-config=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/Tk.framework/tkConfig.sh" # Point to the location of Tk, needs the Xcode command line tools and modification of TCL_INCLUDE_SPEC within the script
    ]

    if build.with? "java"
      args << "--enable-java"
    else
      args << "--disable-java"
    end

    # Help CRAN packages find gettext, readline, openblas and icu4c
    ["gettext", "readline", "openblas", "icu4c"].each do |f|
      ENV.append "CPPFLAGS", "-I#{Formula[f].opt_include}"
      ENV.append "LDFLAGS", "-L#{Formula[f].opt_lib}"
    end

    system "./configure", *args
    system "make"
    ENV.deparallelize do
      system "make", "install"
    end

    cd "src/nmath/standalone" do
      system "make"
      ENV.deparallelize do
        system "make", "install"
      end
    end

    r_home = lib/"R"

    # make Homebrew packages discoverable for R CMD INSTALL
    inreplace r_home/"etc/Makeconf" do |s|
      s.gsub!(/^CPPFLAGS =.*/, "\\0 -I#{HOMEBREW_PREFIX}/include")
      s.gsub!(/^LDFLAGS =.*/, "\\0 -L#{HOMEBREW_PREFIX}/lib")
      s.gsub!(/.LDFLAGS =.*/, "\\0 $(LDFLAGS)")
    end

    include.install_symlink Dir[r_home/"include/*"]
    lib.install_symlink Dir[r_home/"lib/*"]

    # avoid triggering mandatory rebuilds of r when gcc is upgraded
    inreplace lib/"R/etc/Makeconf", Formula["gcc"].prefix.realpath,
                                    Formula["gcc"].opt_prefix
  end

  def post_install
    short_version =
      `#{bin}/Rscript -e 'cat(as.character(getRversion()[1,1:2]))'`.strip
    site_library = HOMEBREW_PREFIX/"lib/R/#{short_version}/site-library"
    site_library.mkpath
    ln_s site_library, lib/"R/site-library"
  end

  test do
    assert_equal "[1] 2", shell_output("#{bin}/Rscript -e 'print(1+1)'").chomp
    assert_equal ".dylib", shell_output("#{bin}/R CMD config DYLIB_EXT").chomp

    testpath.install resource("gss")
    system bin/"R", "CMD", "INSTALL", "--library=.", Dir["gss*"].first
    assert_predicate testpath/"gss/libs/gss.so", :exist?,
                     "Failed to install gss package"
  end
end
