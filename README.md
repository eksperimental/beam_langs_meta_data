# BeamLangsMetaData

## Introduction

`BeamLangsMetaData` provides meta-data for BEAM languages.

Currently Elixir and Erlang/OTP are supported. More languages will be added if there's interest.

`BeamLangsMetaData` - is a small library which contains JSON files including:
  - every Elixir release and prerelease starting from v1.0.0
  - and Erlang/OTP releases and prereleases starting from Erlang/OTP 17.0
  - the [compatibility table between the two languages](https://hexdocs.pm/elixir/compatibility-and-deprecations.html#compatibility-between-elixir-and-erlang-otp)

The information in this module is regularly updated, and stored with every new release of this library.

This library does not download information neither at compile time nor at run time.

`BeamLangsMetaData.Json` provides functions to return the JSON files stored in this project. 

This library is aimed at Elixir developers who need to access up-to-date information.
If you are a developer and need more refined information, please have a look at its sister library
[ElixirMeta](https://github.com/eksperimental/elixir_meta).

## Important Notice

Due to the nature of the project and since we have not reached `v1.0` yet, only the latest `v0.MINOR` versions will be update with the latest meta-data. Older packages will be [retired](`Mix.Tasks.Hex.Retire`) and you will get a warning when using them indicating that you need to update your library.

## Repository and Packages

This source code is freely available at <https://github.com/eksperimental/beam_langs_meta_data>

Packages are regularly updated.
All published packages can be found on Hex: <https://hex.pm/packages/beam_langs_meta_data>


## Installation

The package can be installed by adding `beam_langs_meta_data` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:beam_langs_meta_data, "~> 0.2.1"},
  ]
end
```

## Documentation

Online documentation can be found at <https://hexdocs.pm/beam_langs_meta_data>


## Feature Requests

Feel free to open up an issue <https://github.com/eksperimental/beam_langs_meta_data/issues> with your request.


## Development

Install the repository locally. You can run the validations by running:

`mix validate` which is an alias for:

- `mix format --check-formatted`
- `mix deps.unlock --check-unused`
- `mix compile --warnings-as-errors`
- `mix dialyzer`
- `mix docs`
- `mix credo`

Run tests by executing:
`mix test`


## Road Map

1. Automatic package publishing on every OTP and Elixir new release.
2. Detect update if the release data gets updated.

## Contact

Eksperimental <eskperimental (at) autistici (dot) org>


## License

No Copyright

This work is released to the
[Public Domain](https://creativecommons.org/publicdomain/mark/1.0/) and multi-licensed under the
[Creative Commons Zero Universal version 1.0 license](https://creativecommons.org/publicdomain/zero/1.0/),
the [MIT No Attribution license](https://spdx.org/licenses/MIT-0.html),
and the [BSD Zero Clause license](https://opensource.org/licenses/0BSD).

You can choose between one of them if you use this work.

The author, [Eksperimental](https://github.com/eksperimental) has dedicated the work to the
public domain by waiving all copyright and related or neighboring rights to this work worldwide
under copyright law including all related and neighboring rights, to the extent allowed by law.

You can copy, modify, distribute and create derivative work, even for commercial purposes, all
without asking permission. Giving credits is appreciated though;
you may link to this repository if you wish.

<p xmlns:dct="https://purl.org/dc/terms/">
  <a rel="license" href="https://creativecommons.org/publicdomain/mark/1.0/">
    <img src="https://i.creativecommons.org/p/mark/1.0/88x31.png"
       style="border-style: none;" alt="Public Domain Mark" />
  </a><br />
  <a rel="license"
     href="https://creativecommons.org/publicdomain/zero/1.0/">
    <img src="https://i.creativecommons.org/p/zero/1.0/88x31.png" style="border-style: none;" alt="Creative Commons Zero" />
  </a>
</p>

Check the [LICENSES/LICENSE.CC0-1.0.txt](LICENSES/LICENSE.CC0-1.0.txt),
[LICENSES/LICENSE.MIT-0.txt](LICENSES/LICENSE.MIT-0.txt),
[LICENSES/LICENSE.0BSD.txt](LICENSES/LICENSE.0BSD.txt) files for more information.

`SPDX-License-Identifier: CC0-1.0 or MIT-0 or 0BSD`
