class Arf < Formula
  desc "Modern R console written in Rust"
  homepage "https://github.com/eitsupi/arf"
  url "https://github.com/eitsupi/arf/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "c2f7ac073d17063417e9bb026fd226dd39c31b350d3d26c305fe7ee149711f4a"
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
