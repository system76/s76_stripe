defmodule Stripe.Token do
  @moduledoc """
  The Stripe Token object.

  See https://stripe.com/docs/api/curl#tokens for further details.
  """

  alias Stripe.{API, Token}

  @endpoint "tokens"

  defstruct [
    id: nil,
    bank_account: nil,
    card: nil,
    client_ip: nil,
    created: DateTime.from_unix!(0),
    livemode: false,
    type: :card,
    used: false,
  ]

  @type t :: %Token{
    id: nil | String.t,
    bank_account: nil, # Stripe.reference(BankAccount.t)
    card: nil, # Stripe.reference(Card.t)
    client_ip: nil | String.t,
    created: DateTime.t,
    livemode: boolean,
    type: :bank_account | :card,
    used: boolean,
  }

  @doc "See https://stripe.com/docs/api/curl#create_card_token"
  @spec create(map) :: API.response(t)
  def create(params) do
    @endpoint |> API.post(params) |> API.format_response()
  end

  # TODO def retrieve

  @doc false
  @spec format(map) :: t
  def format(raw_token) do
    %Token{
      id: raw_token["id"],
      bank_account: nil, # TODO Stripe.format(raw_token["bank_account"])
      card: nil, # TODO: Stripe.format(raw_token["card"]),
      created: Stripe.format_timestamp(raw_token["created"]),
      livemode: raw_token["livemode"],
      type: Stripe.format_enum(raw_token["type"]),
      used: raw_token["used"],
    }
  end
end
