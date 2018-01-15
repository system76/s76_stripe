# Stripe

An API client for Stripe.

This is written against version 2015-04-07 of the Stripe API.

**NB** This is *not* complete. It is an extraction from a running system and
contains only the resources and endpoints the system is currently using.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `s76_stripe` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:s76_stripe, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/s76_stripe](https://hexdocs.pm/s76_stripe).

## Configuration

You must either set `config :s76_stripe, :private_key, key` or set the
`$STRIPE_PRIVATE_KEY` environment variable.

To use webhooks, you must additionally either set `config :s76_stripe,
:webhook_secret, secret` or set the `$STRIPE_WEBHOOK_SECRET` environment
variable.
