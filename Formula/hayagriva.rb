class Hayagriva < Formula
  desc "Rusty bibliography management for Typst"
  homepage "https://github.com/typst/hayagriva"
  url "https://github.com/typst/hayagriva/archive/refs/tags/v0.8.1.zip"
  sha256 "20316adfebd9a5d70a8f8ee784f4bff707b9e84287cef0b5d0c687befba79fea"
  license all_of: ["MIT", "Apache-2.0"]

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
