defmodule Peergym.Mixfile do
  use Mix.Project

  def project do
    [app: :peergym,
     version: "0.0.4",
     elixir: "~> 1.1",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {Peergym, []},
     applications: [:phoenix, :phoenix_html, :cowboy, :logger,
                    :phoenix_ecto, :postgrex, :erlcloud]]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [{:phoenix, "~> 1.0.3"},
     {:phoenix_html, "~> 2.2.0"},
     {:phoenix_ecto, "~> 1.2.0"},
     {:postgrex, ">= 0.9.1"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:cowboy, "~> 1.0"},
     {:passport, "~> 0.0.3", github: "acconrad/passport", override: true},
     {:poison, "~> 1.5"},
     {:ex_machina, "~> 0.4"},
     {:scrivener, "~> 1.1.0"},
     {:number, "~> 0.4.0"},
     {:arc, "~> 0.1.4"},
     {:arc_ecto, "~> 0.2.0"},
     {:credo, "~> 0.1.9", only: [:dev, :test]},
     {:earmark, "~> 0.1.19"}]
  end
end
