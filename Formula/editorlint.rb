class Editorlint < Formula
  desc "A comprehensive tool to validate and fix files according to .editorconfig specifications"
  homepage "https://github.com/cdobbyn/editorlint"
  license "MIT"
  version "1.3.9"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/cdobbyn/editorlint/releases/download/1.3.9/editorlint_v1.3.9_darwin_arm64.tar.gz"
      sha256 "9cece0ffe7cad27ff7fcb1c337fe9443ae5b5bf872f179491e00ecf629d6db75"
    else
      url "https://github.com/cdobbyn/editorlint/releases/download/1.3.9/editorlint_v1.3.9_darwin_amd64.tar.gz"
      sha256 "36d79bf043239a159aac280e050511da91a44f1b5a91e67b56bb8f4b7dc8dfd2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/cdobbyn/editorlint/releases/download/1.3.9/editorlint_v1.3.9_linux_arm64.tar.gz"
      sha256 "905f998166df2ead06e0363f178883651169a5bf7960b476ebd0fa1ce60a23e1"
    else
      url "https://github.com/cdobbyn/editorlint/releases/download/1.3.9/editorlint_v1.3.9_linux_amd64.tar.gz"
      sha256 "586a4966758dba043d62729c2e3da24f1adea24994c2772a88694e95416da2f4"
    end
  end

  def install
    bin.install "editorlint"
  end

  test do
    # Create a test .editorconfig file
    (testpath/".editorconfig").write <<~EOS
      root = true

      [*]
      insert_final_newline = true
      trim_trailing_whitespace = true
    EOS

    # Create a test file with violations
    (testpath/"test.txt").write "test with trailing spaces   "

    # Run editorlint and expect it to find violations
    output = shell_output("#{bin}/editorlint test.txt", 1)
    assert_match "validation failed", output
    assert_match "trim_trailing_whitespace", output

    # Test the fix functionality
    system bin/"editorlint", "--fix", "test.txt"

    # Verify the file was fixed
    fixed_content = File.read(testpath/"test.txt")
    assert_equal "test with trailing spaces
", fixed_content
  end
end

