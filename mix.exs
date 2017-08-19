defmodule Peergym.Mixfile do
  use Mix.Project

  def project do
    [app: :peergym,
     version: "1.1.0",
     elixir: "~> 1.4",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {Peergym, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger,
                    :phoenix_ecto, :postgrex, :geolix, :ex_aws, :hackney, :poison, :arc_ecto]]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [{:phoenix, "~> 1.2.2"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_html, "~> 2.9"},
     {:phoenix_ecto, "~> 3.2.2"},
     {:postgrex, "~> 0.13"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:cowboy, "~> 1.0"},
     {:passport, "~> 0.5.7", github: "acconrad/passport", override: true},
     {:poison, "~> 2.0"},
     {:ex_machina, "~> 2.0"},
     {:scrivener, "~> 2.3"},
     {:number, "~> 0.5"},
     {:arc, "~> 0.8.0"},
     {:arc_ecto, "~> 0.7.0"},
     {:credo, "~> 0.7.3", only: [:dev, :test]},
     {:earmark, "~> 1.2"},
     {:geolix, "~> 0.13"},
     {:plug_forwarded_peer, "~> 0.0.2"},
     {:ex_aws, "~> 1.1"},
     {:hackney, "~> 1.6"},
     {:sweet_xml, "~> 0.6"},
     {:gettext, "~> 0.11"}]
  end
end
