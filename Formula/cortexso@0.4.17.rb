
class Cortexso < Formula
  desc "Drop-in, local AI alternative to the OpenAI stack"
  homepage "https://jan.ai/cortex"
  license "Apache-2.0"
  head "https://github.com/janhq/cortex.git", branch: "dev"
  version "0.4.17"

  on_macos do
    on_arm do
      url "https://github.com/janhq/cortex/releases/download/v#{version}/cortex-#{version}-arm64-mac.tar.gz"
      sha256 "3b5a23a073a43a65ed295905833f6c3fe92773374607f68e6ecc8358d2e6a100"
    end
    on_intel do
      url "https://github.com/janhq/cortex/releases/download/v#{version}/cortex-#{version}-amd64-mac.tar.gz"
      sha256 "568948b8bdbda8cbe99288289a07cbad2b5b560150e488b64223f04bc7fd65b7"
    end
  end
  on_linux do
    url "https://github.com/janhq/cortex/releases/download/v#{version}/cortex-#{version}-amd64-linux.tar.gz"
    sha256 "1004c11cfd6211b10a65c3eda9933ef937ac18975f8c3ee08e7781fa8201aa9e"
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
