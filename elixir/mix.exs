defmodule AitlasSchema.MixProject do
  use Mix.Project

  def project do
    [
      app: :aitlas_schema,
      version: "0.1.0",
      elixir: "~> 1.15",
      deps: deps(),
      description: "Shared database schemas for Aitlas projects",
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ecto, "~> 3.11"},
      {:ecto_sql, "~> 3.11"},
      {:postgrex, "~> 0.19"}
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/Fuuurma/aitlas-schema"}
    ]
  end
end