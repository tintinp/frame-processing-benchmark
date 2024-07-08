defmodule FrameProcessingBenchmark.MixProject do
  use Mix.Project

  def project do
    [
      app: :frame_processing_benchmark,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:benchee, "~> 1.0", only: :dev},
      {:evision, "~> 0.2"},
      {:image, "~> 0.37"}
    ]
  end
end
