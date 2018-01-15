defmodule Stripe.BalanceTransaction do
  @moduledoc """
  The Stripe Balance Transaction object.

  See https://stripe.com/docs/api/curl#balance for further details.
  """

  alias Stripe.{BalanceTransaction}

  @endpoint "balance/history"

  defstruct [
    id: nil,
    amount: Decimal.new(0),
    available_on: DateTime.from_unix!(0),
    created: DateTime.from_unix!(0),
    currency: "usd",
    description: "",
    fee: Decimal.new(0),
    # fee_details: nil,
    net: Decimal.new(0),
    source: nil,
    status: :pending,
    type: :charge,
  ]

  @type t :: %BalanceTransaction{
    id: nil | String.t,
    amount: Decimal.t,
    available_on: DateTime.t,
    created: DateTime.t,
    currency: Stripe.currency_code,
    description: String.t,
    # exchange_rate: nil | Decimal.t,
    fee: Decimal.t,
    # fee_details: nil | %{
    #   amount: Decimal.t,
    #   application: String.t,
    #   currency: Stripe.currency_code,
    #   description: String.t,
    #   type: :application_fee | :stripe_fee | :tax,
    # },
    net: Decimal.t,
    source: nil | String.t, # Stripe.reference(Source.t),
    status: :available | :pending,
    type: :adjustment | :application_fee | :application_fee_refund | :charge |
          :payment | :payment_failure_refund | :payment_refund | :refund |
          :transfer | :transfer_refund | :payout | :payout_cancel |
          :payout_failure | :validation | :stripe_fee,
  }

  # TODO def retrieve

  @doc false
  def format(raw_balance_transaction) do
    %BalanceTransaction{
      id: raw_balance_transaction["id"],
      amount: Stripe.format_currency(raw_balance_transaction["amount"]),
      available_on: Stripe.format_timestamp(raw_balance_transaction["available_on"]),
      created: Stripe.format_timestamp(raw_balance_transaction["created"]),
      currency: raw_balance_transaction["currency"],
      description: raw_balance_transaction["description"],
      fee: Stripe.format_currency(raw_balance_transaction["fee"]),
      net: Stripe.format_currency(raw_balance_transaction["net"]),
      source: raw_balance_transaction["source"],
              # TODO: Stripe.format(raw_balance_transaction["source"]),
      status: Stripe.format_enum(raw_balance_transaction["status"]),
      type: Stripe.format_enum(raw_balance_transaction["type"]),
    }
  end
end
