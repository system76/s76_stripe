defmodule Stripe.Mixfile do
  use Mix.Project

  def project do
    [
      app: :s76_stripe,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:decimal, "~> 1.4"},
      {:httpoison, "~> 0.13"},
      {:poison, "~> 3.0"},
      {:plug, "~> 1.4"},
    ]
  end
end
