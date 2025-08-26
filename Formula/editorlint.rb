class Editorlint < Formula
  desc "A comprehensive tool to validate and fix files according to .editorconfig specifications"
  homepage "https://github.com/dobbo-ca/editorlint"
  license "MIT"
  version "0.2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/dobbo-ca/editorlint/releases/download/0.2.0/editorlint_v0.2.0_darwin_arm64.tar.gz"
      sha256 "294dd8899d2c04dc136980b1ec65e7f8ab5e8137edac9e0c373340d472ae4fc9"
    else
      url "https://github.com/dobbo-ca/editorlint/releases/download/0.2.0/editorlint_v0.2.0_darwin_amd64.tar.gz"
      sha256 "a6d426e5ebad5f22220a1586ea319f619e5ba114bf6370afac6aa71ab6e27d9a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/dobbo-ca/editorlint/releases/download/0.2.0/editorlint_v0.2.0_linux_arm64.tar.gz"
      sha256 "06445a590b2e3a3081ef84c3058e2efeb99c823e03d97cdb611ef43d92c5f108"
    else
      url "https://github.com/dobbo-ca/editorlint/releases/download/0.2.0/editorlint_v0.2.0_linux_amd64.tar.gz"
      sha256 "0fa4823b18ef63236bb4f101ea74259a020a3abbd9f964021629ad4a6425d8d8"
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

