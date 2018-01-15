defmodule StripeTest do
  use ExUnit.Case
  doctest Stripe

  test "greets the world" do
    assert Stripe.hello() == :world
  end
end
