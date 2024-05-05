defmodule EctoMermaid.MixProject do
  use Mix.Project

  def project do
    [
      app: :ecto_mermaid,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      source_url: "https://github.com/poncho/ecto_mermaid"
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
      {:ecto_sql, "~> 3.0"},
      {:ex_doc, "~> 0.32", only: :dev, runtime: false}
    ]
  end

  defp description() do
    "Ecto extension to create Entity Relationship Diagrams using Mermaid"
  end

  defp package() do
    [
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/poncho/ecto_mermaid",
        "Mermaid" => "https://mermaid.js.org"
      }
    ]
  end
end
