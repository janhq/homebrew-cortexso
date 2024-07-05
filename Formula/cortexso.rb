require "language/node"

class Cortexso < Formula
  desc "Drop-in, local AI alternative to the OpenAI stack"
  homepage "https://jan.ai/cortex"
  url "https://registry.npmjs.org/cortexso/-/cortexso-0.1.0.tgz"
  sha256 "ad32120974c37b1e6bb8e745edf83ccf611045b38a21bafb8cd55fe2c638aeb9"
  license "Apache-2.0"
  head "https://github.com/janhq/cortex.git", branch: "dev"

  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => :build
  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    port = free_port
    pid = fork { exec "#{bin}/cortex", "serve", "--port", port.to_s }
    sleep 5
    begin
      assert_match "OK", shell_output("curl -s localhost:#{port}/v1/health")
    ensure
      Process.kill "SIGTERM", pid
    end
  end
end
