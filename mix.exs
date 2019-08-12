defmodule Stripe.Mixfile do
  use Mix.Project

  def project do
    [
      app: :s76_stripe,
      version: "0.1.5",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "S76 Stripe",
      source_url: "https://github.com/system76/s76_stripe",
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
      {:decimal,    "~> 1.8"},
      {:httpoison,  "~> 1.0"},
      {:poison,     "~> 4.0"},
      {:plug,       "~> 1.8"},

      # Development and testing only dependencies
      {:dialyxir,   "~> 0.5", only: :dev, runtime: false},
      {:ex_doc,     "~> 0.21", only: :dev},
    ]
  end

  defp description do
    "An API client for Stripe"
  end

  defp package do
    [
      name: "s76_stripe",
      maintainers: ["Ben Cates"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/system76/s76_stripe"},
    ]
  end
end
