defmodule BeamLangsMetaData.MixProject do
  use Mix.Project

  @app :beam_langs_meta_data
  @name "BeamLangsMetaData"
  @repo_url "https://github.com/eksperimental/beam_langs_meta_data"

  @description """
  Provides meta-data for BEAM languages.

  Currently Elixir and Erlang/OTP are supported.

  The information in this module is regularly updated, and stored with every new release of this library.
  This library does not download information neither at compile time nor at run time.
  """

  def project do
    [
      app: @app,
      version: "0.2.1",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      description: @description,
      aliases: aliases(),
      package: package(),
      deps: deps(),

      # Docs
      name: @name,
      source_url: @repo_url,
      # homepage_url: @repo_url,
      docs: docs()
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
      setup: [
        "deps.get",
        "deps.update --all"
      ],
      prepare: [
        "format",
        "deps.clean --unused --unlock",
        "deps.unlock --unsued"
      ],
      validate: [
        "format --check-formatted",
        "deps.unlock --check-unused",
        "compile",
        "compile --warnings-as-errors",
        "dialyzer",
        "docs",
        "credo --ignore Credo.Check.Design.TagTODO"
      ],
      all: [
        "setup",
        "prepare",
        "validate",
        test_isolated()
      ]
    ]
  end

  defp test_isolated() do
    fn _args ->
      env_test = %{"MIX_ENV" => "test"}

      with {:"test setup", {_, 0}} <-
             {:"test setup", System.cmd("mix", ~w[setup], env: env_test)},
           {:test, {_, 0}} <- {:test, System.cmd("mix", ~w[test], env: env_test)} do
        true
      else
        {type, {output, _}} ->
          IO.puts(output)
          raise("#{type} failed.")
      end
    end
  end

  defp package do
    [
      maintainers: ["Eksperimental"],
      licenses: ["CC0-1.0", "MIT-0", "0BSD"],
      links: %{"GitHub" => @repo_url},
      source_url: @repo_url
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.2"},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:credo, "~> 1.6", only: [:dev], runtime: false},
      {:gradient, github: "esl/gradient", only: [:dev], runtime: false},
      {:ex_doc, "~> 0.28", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      # The main page in the docs
      main: @name,
      authors: ["Eksperimental"],
      extras: [
        "README.md": [filename: "readme", title: "Readme"],
        # "NOTICE": [filename: "notice", title: "Notice"],
        "LICENSES/LICENSE.CC0-1.0.txt": [
          filename: "license_CC0-1.0",
          title: "Creative Commons Zero Universal version 1.0 License"
        ],
        "LICENSES/LICENSE.MIT-0.txt": [
          filename: "license_MIT-0",
          title: "MIT No Attribution License"
        ],
        "LICENSES/LICENSE.0BSD.txt": [
          filename: "license_0BSD",
          title: "BSD Zero Clause License"
        ]
      ],
      groups_for_extras: [
        Licenses: ~r{LICENSES/}
      ],
      source_ref: revision()
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
