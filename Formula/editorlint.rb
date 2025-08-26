class Editorlint < Formula
  desc "A comprehensive tool to validate and fix files according to .editorconfig specifications"
  homepage "https://github.com/dobbo-ca/editorlint"
  license "MIT"
  version "0.3.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/dobbo-ca/editorlint/releases/download/0.3.0/editorlint_v0.3.0_darwin_arm64.tar.gz"
      sha256 "a49bfbcbeeeca6be9151bd7e53f6ec4cf4c3cdd0f80759458a11557cd5fc8cd7"
    else
      url "https://github.com/dobbo-ca/editorlint/releases/download/0.3.0/editorlint_v0.3.0_darwin_amd64.tar.gz"
      sha256 "8f5cc1563e2710ab6ac8d1e7f88f9ac5189fb78480fd56b8a404dbdf8756344f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/dobbo-ca/editorlint/releases/download/0.3.0/editorlint_v0.3.0_linux_arm64.tar.gz"
      sha256 "311c191ed04e3da19eb4558413c43fd8f0968a9446c2377550f3508e40e79faf"
    else
      url "https://github.com/dobbo-ca/editorlint/releases/download/0.3.0/editorlint_v0.3.0_linux_amd64.tar.gz"
      sha256 "70736267981aca8efd187a27d26e68ed7785d7d42d2331ac0d3bb5b207835dca"
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

