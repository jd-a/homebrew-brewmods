class Arf < Formula
  desc "A modern R console written in Rust "
  homepage "https://github.com/eitsupi/arf"
  url "https://github.com/eitsupi/arf/archive/refs/tags/v0.2.6.zip"
  sha256 "cda3aefa438d5b738d00a071249f3f9d53441a4c2a2bb68acc4418d574056f2b"
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
