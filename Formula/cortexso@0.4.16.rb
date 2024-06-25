
class Cortexso < Formula
  desc "Drop-in, local AI alternative to the OpenAI stack"
  homepage "https://jan.ai/cortex"
  license "Apache-2.0"
  head "https://github.com/janhq/cortex.git", branch: "dev"
  version "0.4.16"

  on_macos do
    on_arm do
      url "https://github.com/janhq/cortex/releases/download/v#{version}/cortex-#{version}-arm64-mac.tar.gz"
      sha256 "b03a139a77e88af962bef130b88de729e6598a0b29a750a7a6f52325d37f5b79"
    end
    on_intel do
      url "https://github.com/janhq/cortex/releases/download/v#{version}/cortex-#{version}-amd64-mac.tar.gz"
      sha256 "34ac85c702e16ca912fe23fffd4b2c9ad23b4cd942baae9f3f25d80efba228c9"
    end
  end
  on_linux do
    url "https://github.com/janhq/cortex/releases/download/v#{version}/cortex-#{version}-amd64-linux.tar.gz"
    sha256 "49455f4ba0db0b111bdaf2e6f5647fb2cd68adf77dd28a0f931f31503a105ddf"
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
