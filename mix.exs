defmodule Clamex.MixProject do
  use Mix.Project

  def project do
    [
      app: :clamex,
      version: "0.2.2",
      elixir: "~> 1.3",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
      description: description(),
      name: "Clamex",
      source_url: "https://github.com/szajbus/clamex",
      docs: docs()
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:ex_doc, "~> 0.19", only: :dev}
    ]
  end

  defp package do
    [
      name: "clamex",
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/szajbus/clamex"}
    ]
  end

  defp description do
    "Thin, error-friendly and testable wrapper for ClamAV"
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"]
    ]
  end
end
