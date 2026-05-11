class Arf < Formula
  desc "Modern R console written in Rust"
  homepage "https://github.com/eitsupi/arf"
  url "https://github.com/eitsupi/arf/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "54859e9d9517b2df1f0149bf9a0ac91e8d4874a1854b79f252c99a8bfce68392"
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
