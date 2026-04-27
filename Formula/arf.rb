class Arf < Formula
  desc "Modern R console written in Rust"
  homepage "https://github.com/eitsupi/arf"
  url "https://github.com/eitsupi/arf/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "e93610f8c4b31d1f0deb5165a9f0133c4450e54cb1c2227f145045e9a525cece"
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
