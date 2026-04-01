class Arf < Formula
  desc "A modern R console written in Rust "
  homepage "https://github.com/eitsupi/arf"
  url "https://github.com/eitsupi/arf/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "f8a646da9d967851b076889aaef9262a97c5f6da180449316f334bb3758b9528"
  license "MIT"

  depends_on "rust" => :build

  def install
    # Build and install
    system "cargo", "install",
           *std_cargo_args(path: "crates/arf-console")
  end

  test do
    # Version check
    assert_match version.to_s, shell_output("#{bin}/arf --version")
  end
end
