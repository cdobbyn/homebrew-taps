class Editorlint < Formula
  desc "A comprehensive tool to validate and fix files according to .editorconfig specifications"
  homepage "https://github.com/cdobbyn/editorlint"
  license "MIT"
  version "1.3.9"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/cdobbyn/editorlint/releases/download/1.3.9/editorlint_v1.3.9_darwin_arm64.tar.gz"
      sha256 "darwin_arm64_sha256_placeholder"
    else
      url "https://github.com/cdobbyn/editorlint/releases/download/1.3.9/editorlint_v1.3.9_darwin_amd64.tar.gz"
      sha256 "darwin_amd64_sha256_placeholder"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/cdobbyn/editorlint/releases/download/1.3.9/editorlint_v1.3.9_linux_arm64.tar.gz"
      sha256 "linux_arm64_sha256_placeholder"
    else
      url "https://github.com/cdobbyn/editorlint/releases/download/1.3.9/editorlint_v1.3.9_linux_amd64.tar.gz"
      sha256 "linux_amd64_sha256_placeholder"
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

