class RExtendedcapabilities < Formula
  desc "Software environment for statistical computing with extended capabilities"
  homepage "https://www.r-project.org/"
  url "http://cran.r-project.org/src/base/R-4/R-4.1.0.tar.gz"
  sha256 "e8e68959d7282ca147360fc9644ada9bd161bab781bab14d33b8999a95182781"

  depends_on "pkg-config" => :build
  depends_on "gcc" # for gfortran
  depends_on "gettext"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "pcre2"
  depends_on "readline"
  depends_on "xz"

  depends_on "freetype"
  depends_on "fontconfig"
  depends_on "libx11"
  depends_on "libxt"
  depends_on "libxext"
  depends_on "libxmu"
  ## - Cairo must be build with with X11 support. Use brew install jd-a/homebrew-brewmods/cairo-withx
  depends_on "jd-a/homebrew-brewmods/cairo-withx" => :optional 
  depends_on "openblas" => :optional
  depends_on "openjdk" => :optional
  depends_on "texinfo" => :optional
  depends_on "libtiff" => :optional
  depends_on "icu4c" => :optional
  # depends_on "pango" => :optional
  #depends_on "homebrew/cask/tcl" # Use ActiveState tcl-tk

  ## Needed to preserve executable permissions on files without shebangs
  skip_clean "lib/R/bin", "lib/R/doc"

  def install
    ## Fix dyld: lazy symbol binding failed: Symbol not found: _clock_gettime
    if MacOS.version == "10.11" && MacOS::Xcode.installed? &&
       MacOS::Xcode.version >= "8.0"
      ENV["ac_cv_have_decl_clock_gettime"] = "no"
    end

    ## YT - enable tcl-tk support using system headers
    #if MacOS.version >= "10.15" 
    #  ## YT - Set up some  environment variables and over-write some variables defined in tclConfig.sh and tkConfig.sh 
    #  ENV["TCL_INCLUDE_SPEC"] = "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework/Versions/8.5/Headers"
    #  ENV["TK_INCLUDE_SPEC"] = "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers"
    #  ENV["TCLTK_CPPFLAGS"] = "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework/Versions/8.5/Headers \
    #            -I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers"
    #  ENV["TCLTK_LIBS"] = "-F#{MacOS.sdk_path}/System/Library/Frameworks -framework Tk \
    #           -F#{MacOS.sdk_path}/System/Library/Frameworks -framework Tcl"
    #end

    ## SRF - Add Tex to path, uncomment if mactex is installed and desired
    #ENV.append_path "PATH", "/Library/TeX/texbin"

    ## YT - If homebrew's tcl-tk is to be used, this line should be uncommented
    #tcl_lib = Formula["tcl-tk"].opt_lib
    
    args = [
      "--prefix=#{prefix}",
      "--enable-memory-profiling",
      "--with-x", # Add X11 support (comment --without-x). Necessary for Apple tcl-tk support.
      #"--without-x", # YT - If Homebrew's tcl-tk is to be used, '--with-x' cause an error.
      "--with-aqua",
      "--with-lapack",
      "--enable-R-shlib",
      "SED=/usr/bin/sed", # don't remember Homebrew's sed shim
      "--with-tcltk", # Add tcl-tk support.
      "--with-tcl-config=/Library/Frameworks/Tcl.framework/tclConfig.sh", # ActiveState Tcl
      "--with-tk-config=/Library/Frameworks/Tk.framework/tkConfig.sh" # ActiveState Tk
      #"--with-tcl-config=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework/tclConfig.sh", # If Apple's tcl-tk is to be used, this line should be uncommented
      #"--with-tk-config=#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/tkConfig.sh", # If Apple's tcl-tk is to be used, this line should be uncommented
      #"--with-tcl-config=#{tcl_lib}/tclConfig.sh", # YT - If homebrew's tcl-tk is to be used, this line should be uncommented
      #"--with-tk-config=#{tcl_lib}/tkConfig.sh" # YT - If homebrew's tcl-tk is to be used, this line should be uncommented
    ]
    
    ## Add supporting flags for optional packages
    if build.with? "openblas"
      args << "--with-blas=-L#{Formula["openblas"].opt_lib} -lopenblas"
      ENV.append "LDFLAGS", "-L#{Formula["openblas"].opt_lib} -lopenblas"
    else
      args << "--with-blas=-framework Accelerate"
      ENV.append_to_cflags "-D__ACCELERATE__" if ENV.compiler != :clang
    end

    if build.with? "openjdk"
      args << "--enable-java"
    else
      args << "--disable-java"
    end

    if build.with? "cairo-withx"
      args << "--with-cairo"
    else
      args << "--without-cairo"
    end

    if build.with? "icu4c"
      ENV.append "CPPFLAGS", "-I#{Formula["icu4c"].opt_include}"
      ENV.append "LDFLAGS", "-L#{Formula["icu4c"].opt_lib}"
    end

    # Help CRAN packages find gettext and readline
    ["gettext", "readline", "xz"].each do |f|
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
    # assert_equal "[1] \"aqua\"", shell_output("#{bin}/Rscript -e 'library(tcltk)' -e 'tclvalue(.Tcl(\"tk windowingsystem\"))'").chomp

    system bin/"Rscript", "-e", "install.packages('gss', '.', 'https://cloud.r-project.org')"
    assert_predicate testpath/"gss/libs/gss.so", :exist?,
                     "Failed to install gss package"
  end
end
