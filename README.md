# BeamLangsMetaData

Provides meta-data for Elixir and Erlang/OTP.

The information in this module is regularly updated, and stored with every new release of this library.
This library does not download information neither at compile time nor at real time.

This library is aimed at Elixir developers who need to access up-to-date information.
If you are a developer and need more refined information, please have a look at its sister library
[BeamLangsMetaData](https://github.com/eksperimental/beam_langs_meta_data).

## Repository and Packages

This source code is freely available at <https://github.com/eksperimental/beam_langs_meta_data>

Packages are regularly updated.
All published packages can be found on Hex: <https://hex.pm/packages/beam_langs_meta_data>


## Installation

The package can be installed by adding `beam_langs_meta_data` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:beam_langs_meta_data, "~> 0.1.0"},
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
- `mix dialyzer`
- `mix docs`
- `mix credo`

Run tests by executing:
`mix test`


## Future Plans

Soon, this information will automatically be updated and released as a new package version as soon as a new
Elixir version is released.

I am planning to include the information for all Erlang/OTP releases.

Currently once a new entry is added, it is not checked whether this entry has been udpated. I am planning to check for this as well.


## Contact

Eksperimental <eskperimental (at) autistici (dot) org>


## License

BeamLangsMetaData source code is licensed under the [MIT License](LICENSE.md).