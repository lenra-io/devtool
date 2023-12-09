defmodule DevTool.MixProject do
  use Mix.Project

  def project do
    [
      app: :dev_tools,
      version: "0.0.0-dev",
      config_path: "config/config.exs",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      dialyzer: [plt_add_apps: [:mix]],
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      releases: [
        dev_tools: [
          applications: [
            dev_tools: :permanent,
            runtime_tools: :permanent
          ],
          include_executables_for: [:unix]
        ]
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {DevTool.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: :test},
      {:bypass, "~> 2.0", only: :test},
      {:phoenix, "~> 1.6.15"},
      {:telemetry, "~> 0.4", override: true},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:finch, "~> 0.14.0"},
      {:ecto_sql, "~> 3.9.2"},
      {:postgrex, "~> 0.16.0"},
      {:cors_plug, "~> 3.0"},
      {:application_runner,
       git: "https://github.com/lenra-io/server.git",
       ref: "v1.0.3",
       subdir: "libs/application_runner",
       submodules: true},
      {:distillery, "~> 2.1"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": [
        "ecto.create",
        "ecto.migrate"
      ],
      "ecto.migrations": [
        "ecto.migrations --migrations-path priv/repo/migrations --migrations-path deps/application_runner/libs/application_runner/priv/repo/migrations"
      ],
      "ecto.migrate": [
        "ecto.migrate --migrations-path priv/repo/migrations --migrations-path deps/application_runner/libs/application_runner/priv/repo/migrations"
      ],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: [
        "ecto.drop --quiet",
        "ecto.create --quiet",
        "ecto.migrate",
        "test"
      ]
    ]
  end
end
