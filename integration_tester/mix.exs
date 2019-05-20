defmodule IntegrationTester.MixProject do
  use Mix.Project

  def project do
    [
      app: :integration_tester,
      version: "0.1.0",
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env()),
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

  defp elixirc_paths(:test), do: ~w[lib test/support]
  defp elixirc_paths(_), do: ~w[lib]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:freezer_eye, path: "../freezer_eye"},
      {:fe_test_helpers, path: "../fe_test_helpers", only: :test},
      {:bypass, "~> 1.0", only: :test}
    ]
  end
end
