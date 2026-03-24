defmodule AitlasSchema.MixProject do
  use Mix.Project

  def project do
    [
      app: :aitlas_schema,
      version: "0.3.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Shared Ecto schemas for Aitlas ecosystem - one schema to rule them all",
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :ecto, :ecto_sql]
    ]
  end

  defp deps do
    [
      {:ecto, "~> 3.12"},
      {:ecto_sql, "~> 3.12"}
    ]
  end

  defp package do
    [
      name: "aitlas_schema",
      files: ~w(lib priv *.ex mix.exs README* LICENSE*),
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/Fuuurma/aitlas-schema"
      }
    ]
  end
end