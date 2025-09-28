class Hayagriva < Formula
  desc "Rusty bibliography management for Typst"
  homepage "https://github.com/typst/hayagriva"
  url "https://github.com/typst/hayagriva/archive/refs/tags/v0.9.1.zip"
  sha256 "06bd3c33fe9f150459e1741f5f7a6b8232170b5516f7dd9832c5c1c2264a0371"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "rust" => :build

  def install
    # Build and install the CLI (with bundled CSL style archive)
    system "cargo", "install",
           "--features", "cli,archive",
           *std_cargo_args
  end

  test do
    # Version check
    assert_match version.to_s, shell_output("#{bin}/hayagriva --version")

    # Minimal smoke test: show help for a subcommand
    output = shell_output("#{bin}/hayagriva help reference")
    assert_match "reference", output
  end
end
