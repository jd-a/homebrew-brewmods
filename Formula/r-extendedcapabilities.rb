class RExtendedcapabilities < Formula
  desc "Software environment for statistical computing with extended capabilities"
  homepage "https://www.r-project.org/"
  url "http://cran.r-project.org/src/base/R-4/R-4.0.1.tar.gz"
  sha256 "95fe24a4d8d8f8f888460c8f5fe4311cec656e7a1722d233218bc03861bc6f32"

  depends_on :x11 # X11 for Tcl-Tk
  depends_on "pkg-config" => :build
  depends_on "gcc" # for gfortran
  depends_on "gettext"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "pcre2"
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
    url "https://cloud.r-project.org/src/contrib/gss_2.2-2.tar.gz", :using => :nounzip
    mirror "https://mirror.las.iastate.edu/CRAN/src/contrib/gss_2.2-2.tar.gz"
    sha256 "1da4da894378ee730cff9628e8b4d2a0d7dfa344b94e5bce6953e66723c21fe4"
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
      "--with-tcl-config=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/Tcl.framework/tclConfig.sh", # This file needs modification in TCL_INCLUDE_SPEC
      "--with-tk-config=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/System/Library/Frameworks/Tk.framework/tkConfig.sh" # This file needs modification in TK_INCLUDE_SPEC
    ]

    if build.with? "java"
      args << "--enable-java"
    else
      args << "--disable-java"
    end

    # Help CRAN packages find gettext, readline, openblas, pcre2 and icu4c
    ["gettext", "readline", "openblas","pcre2" ,"icu4c"].each do |f|
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
