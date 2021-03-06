defmodule AdafruitIOHTTPClient.MixProject do
  use Mix.Project

  def project do
    [
      app: :adafruit_io_http_client,
      version: "0.1.0",
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: dialyzer()
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
      {:tesla, "~> 1.2.1"},
      {:hackney, "~> 1.6"},
      {:jason, "~> 1.0"},
      {:bypass, "~> 1.0", only: :test},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev], runtime: false},
      {:stream_data, "~> 0.4", only: :test}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp dialyzer do
    [
      ignore_warnings: ".dialyzer_ignore.exs",
      list_unused_filters: true
    ]
  end
end
