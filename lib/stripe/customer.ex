defmodule Stripe.Customer do
  @moduledoc """
  The Stripe Customer object.

  See https://stripe.com/docs/api/curl#customers for further details.
  """

  alias Stripe.{API, Customer, Source}

  @endpoint "customers"

  defstruct [
    id: nil,
    account_balance: Decimal.new(0),
    business_vat_id: nil,
    created: DateTime.from_unix!(0),
    currency: "usd",
    default_source: nil,
    delinquent: false,
    description: nil,
    email: nil,
    livemode: false,
    metadata: %{},
    shipping: nil,
  ]

  @type t :: %Customer{
    id: nil | String.t,
    account_balance: Decimal.t,
    business_vat_id: nil | String.t,
    created: DateTime.t,
    currency: Stripe.currency_code,
    default_source: Stripe.reference(Source.t),
    delinquent: boolean,
    description: nil | String.t,
    # discount: Stripe.reference(Discount.t),
    email: nil | String.t,
    livemode: boolean,
    metadata: Stripe.metadata,
    shipping: nil | %{
      address: %{
        city: nil | String.t,
        country: nil | String.t,
        line1: nil | String.t,
        line2: nil | String.t,
        postal_code: nil | String.t,
        state: nil | String.t,
      },
      name: String.t,
      phone: String.t,
    },
    # sources: Stripe.list(Source.t),
    # subscriptions: Stripe.list(Subscription.t),
  }

  @spec create(map) :: API.response(t)
  def create(params) do
    @endpoint |> API.post(params) |> API.format_response()
  end

  # TODO def retrieve

  # TODO def update

  # TODO def delete

  # TODO def list

  @doc false
  def format(raw_customer) do
    %Customer{
      id: raw_customer["id"],
      account_balance: Stripe.format_currency(raw_customer["account_balance"]),
      business_vat_id: raw_customer["business_vat_id"],
      created: Stripe.format_timestamp(raw_customer["created"]),
      currency: raw_customer["currency"],
      default_source: Stripe.format(raw_customer["default_source"]),
      delinquent: raw_customer["delinquent"],
      description: raw_customer["description"],
      email: raw_customer["email"],
      livemode: raw_customer["livemode"],
      metadata: Stripe.format_metadata(raw_customer["metadata"]),
      shipping: format_shipping(raw_customer["shipping"]),
    }
  end

  defp format_shipping(nil), do: nil
  defp format_shipping(raw_shipping) do
    %{
      address: %{
        city: get_in(raw_shipping, ["address", "city"]),
        country: get_in(raw_shipping, ["address", "country"]),
        line1: get_in(raw_shipping, ["address", "line1"]),
        line2: get_in(raw_shipping, ["address", "line2"]),
        postal_code: get_in(raw_shipping, ["address", "postal_code"]),
        state: get_in(raw_shipping, ["address", "state"]),
      },
      name: raw_shipping["name"],
      phone: raw_shipping["phone"],
    }
  end
end
