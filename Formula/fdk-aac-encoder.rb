class FdkAacEncoder < Formula
  desc "Command-line encoder frontend for libfdk-aac"
  homepage "https://github.com/nu774/fdkaac"
  url "https://github.com/nu774/fdkaac/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "be6de0851c447d132e9bff0141068ee6fec6d37e21973ea9304480c68178058b"
  license "Zlib"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "jd-a/brewmods/fdk-aac"

  def install
    fdk_aac = Formula["jd-a/brewmods/fdk-aac"]

    # fdkaac's configure script uses:
    #
    #   PKG_CHECK_MODULES([FDK_AAC], [fdk-aac])
    #
    # Explicitly expose the pkg-config metadata from our private formula.
    ENV.prepend_path "PKG_CONFIG_PATH", fdk_aac.opt_lib/"pkgconfig"

    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure",
           "--disable-silent-rules",
           "--mandir=#{man}",
           *std_configure_args

    system "make", "install"
  end

  test do
    sample_rate = 44100
    frequency = 440.0
    max_amplitude = 0.2
    num_samples = sample_rate

    samples = Array.new(num_samples) do |i|
      sample = Math.sin(2 * Math::PI * frequency * i / sample_rate)
      (sample * max_amplitude * 32767.0).round
    end

    (testpath/"tone.pcm").binwrite(samples.pack("s<*"))

    system bin/"fdkaac",
           "-R",
           "--raw-channels", "1",
           "--raw-rate", sample_rate.to_s,
           "-m", "1",
           "-o", testpath/"tone.m4a",
           testpath/"tone.pcm",
           "--title", "Test Tone"

    assert_path_exists testpath/"tone.m4a"
  end
end
