defmodule BeamLangsMetaData.MixProject do
  use Mix.Project

  @repo_url "https://github.com/eksperimental/beam_langs_meta_data"

  def project do
    [
      app: :beam_langs_meta_data,
      version: "0.1.0",
      elixir: "~> 1.3",
      start_permanent: Mix.env() == :prod,
      description: """
        Provides meta-data for Elixir and Erlang/OTP.

        The information in this module is regularly updated, and stored with every new release of this library.
        This library does not download information neither at compile time nor at real time.
      """,
      aliases: aliases(),
      package: package(),
      deps: deps(),

      # Docs
      name: "BeamLangsMetaData",
      source_url: @repo_url,
      homepage_url: @repo_url,
      docs: [
        # The main page in the docs
        main: "BeamLangsMetaData",
        # logo: "path/to/logo.png",
        extras: [
          "README.md": [filename: "readme", title: "Readme"],
          "LICENSE.md": [filename: "license", title: "License"]
        ],
        source_ref: revision()
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp aliases do
    [
      validate: ["format --check-formatted", "dialyzer", "docs", "credo"]
    ]
  end

  defp package do
    [
      maintainers: ["Eksperimental"],
      licenses: ["MIT"],
      links: %{"GitHub" => @repo_url},
      files: ~w(
          lib/
          priv/
          LICENSE.md
          mix.exs
          README.md
          .formatter.exs
        )
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.2"},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.6", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.26", only: :dev, runtime: false}
    ]
  end

  # Originally taken from: https://github.com/elixir-lang/elixir/blob/2b0abcebbe9acee4a103c9d02c6bae707f0e9e73/lib/elixir/lib/system.ex#L1019
  # Tries to run "git rev-parse --short=7 HEAD". In the case of success returns
  # the short revision hash. If that fails, returns an empty string.
  defp revision do
    null =
      case :os.type() do
        {:win32, _} -> 'NUL'
        _ -> '/dev/null'
      end

    'git rev-parse --short=7 HEAD 2> '
    |> Kernel.++(null)
    |> :os.cmd()
    |> strip
  end

  defp strip(iodata) do
    :re.replace(iodata, "^[\s\r\n\t]+|[\s\r\n\t]+$", "", [:global, return: :binary])
  end
end
