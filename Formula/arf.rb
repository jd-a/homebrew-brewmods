class Arf < Formula
  desc "Modern R console written in Rust"
  homepage "https://github.com/eitsupi/arf"
  url "https://github.com/eitsupi/arf/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "5b44176ebd75523ff26f932ea1fd8a1a75e51007f5d156473fbaa503ff5af94e"
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
