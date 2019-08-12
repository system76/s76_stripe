defmodule Stripe.Card do
  @moduledoc """
  The Stripe Card object.

  See https://stripe.com/docs/api/curl#cards for further details.
  """

  alias Stripe.{Card, Customer}

  defstruct [
    id: nil,
    address_city: nil,
    address_country: nil,
    address_line1: nil,
    address_line1_check: nil,
    address_line2: nil,
    address_state: nil,
    address_zip: nil,
    address_zip_check: nil,
    brand: "",
    country: "US",
    customer: nil,
    cvc_check: nil,
    dynamic_last4: nil,
    exp_month: 1,
    exp_year: 2000,
    fingerprint: "",
    funding: :unknown,
    last4: "",
    metadata: %{},
    name: nil,
    tokenization_method: nil,
  ]

  @type t :: %Card{
    id: nil | String.t,
    # account: Stripe.reference(Account.t),
    address_city: nil | String.t,
    address_country: nil | String.t,
    address_line1: nil | String.t,
    address_line1_check: nil | :pass | :fail | :unavailable | :unchecked,
    address_line2: nil | String.t,
    address_state: nil | String.t,
    address_zip: nil | String.t,
    address_zip_check: nil | :pass | :fail | :unavailable | :unchecked,
    # available_payout_methods: TODO [:standard] | [:standard, :instant],
    brand: String.t,
    country: String.t, # ISO two-letter country code
    customer: Stripe.reference(Customer.t),
    cvc_check: nil | :pass | :fail | :unavailable | :unchecked,
    # default_for_currency: boolean, # accounts only
    dynamic_last4: nil | String.t,
    exp_month: pos_integer,
    exp_year: pos_integer,
    fingerprint: String.t,
    funding: :credit | :debit | :prepaid | :unknown,
    last4: String.t,
    metadata: Stripe.metadata,
    name: nil | String.t,
    # recipient: Stripe.reference(Recipient.t),
    tokenization_method: nil | :apple_pay | :android_pay,
  }

  # TODO def create
  # TODO def retrieve
  # TODO def update
  # TODO def delete
  # TODO def list

  @doc false
  @spec format(map) :: t
  def format(raw_card) do
    %Card{
      id: raw_card["id"],
      address_city: raw_card["address_city"],
      address_country: raw_card["address_country"],
      address_line1: raw_card["address_line2"],
      address_line1_check: Stripe.format_enum(raw_card["address_line1_check"]),
      address_line2: raw_card["address_line1"],
      address_state: raw_card["address_state"],
      address_zip: raw_card["address_zip"],
      address_zip_check: Stripe.format_enum(raw_card["address_zip_check"]),
      brand: raw_card["brand"],
      country: raw_card["country"],
      customer: Stripe.format(raw_card["customer"]),
      cvc_check: Stripe.format_enum(raw_card["cvc_check"]),
      dynamic_last4: raw_card["dynamic_last4"],
      exp_month: raw_card["exp_month"],
      exp_year: raw_card["exp_year"],
      fingerprint: raw_card["fingerprint"],
      funding: Stripe.format_enum(raw_card["funding"]),
      last4: raw_card["last4"],
      metadata: Stripe.format_metadata(raw_card["metadata"]),
      name: raw_card["name"],
      tokenization_method: Stripe.format_enum(raw_card["tokenization_method"]),
    }
  end
end
