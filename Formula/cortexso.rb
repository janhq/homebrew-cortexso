
class Cortexso < Formula
  desc "Drop-in, local AI alternative to the OpenAI stack"
  homepage "https://jan.ai/cortex"
  license "Apache-2.0"
  head "https://github.com/janhq/cortex.git", branch: "dev"
  version "0.4.17"

  on_macos do
    on_arm do
      url "https://github.com/janhq/cortex/releases/download/v#{version}/cortex-#{version}-arm64-mac.tar.gz"
      sha256 "131807cec90dc70aed3aa50670e00a55aca0148175798a6065e4bab3a7644e84"
    end
    on_intel do
      url "https://github.com/janhq/cortex/releases/download/v#{version}/cortex-#{version}-amd64-mac.tar.gz"
      sha256 "4e28ec51e0ddd72dd3fe66b8137dfc456110f19f1434861a5c7a745603073077"
    end
  end
  on_linux do
    url "https://github.com/janhq/cortex/releases/download/v#{version}/cortex-#{version}-amd64-linux.tar.gz"
    sha256 "92917bba4d593f23e36c11045cd0db408eeaa3833afedb476500398866f2e53c"
  end
  def install
    bin.install "cortex"
  end

  test do
    port = free_port
    pid = fork { exec "#{bin}/cortex", "serve", "--port", port.to_s }
    sleep 10
    begin
      assert_match "OK", shell_output("curl -s localhost:#{port}/health")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
