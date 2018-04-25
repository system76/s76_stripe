defmodule Stripe.Refund do
  @moduledoc """
  The Stripe Refund object.

  See https://stripe.com/docs/api/curl#refunds for further details.
  """

  alias Stripe.{API, BalanceTransaction, Charge, Refund}

  @endpoint "refunds"

  defstruct [
    id: nil,
    amount: Decimal.new(0),
    balance_transaction: nil,
    charge: nil,
    created: DateTime.from_unix!(0),
    currency: "usd",
    failure_balance_transaction: nil,
    failure_reason: nil,
    metadata: %{},
    reason: nil,
    receipt_number: nil,
    status: :pending,
  ]

  @type t :: %Refund{
    id: nil | String.t,
    amount: Decimal.t,
    balance_transaction: Stripe.reference(BalanceTransaction.t),
    charge: Stripe.reference(Charge.t),
    created: DateTime.t,
    currency: Stripe.currency_code,
    failure_balance_transaction: Stripe.reference(BalanceTransaction.t),
    failure_reason: nil | :lost_or_stolen_card | :expired_or_canceled_card |
                    :unknown,
    metadata: Stripe.metadata,
    reason: nil | :duplicate | :fraudulent | :requested_by_customer,
    receipt_number: nil | String.t,
    status: :pending | :succeeded | :failed | :canceled,
  }

  @doc "See https://stripe.com/docs/api/curl#create_refund"
  @spec create(map) :: API.response(t)
  def create(params) do
    @endpoint |> API.post(params) |> API.format_response()
  end

  # TODO def retrieve

  # TODO def update

  # TODO def list

  @doc false
  @spec format(map) :: t
  def format(raw_refund) do
    %Refund{
      id: raw_refund["id"],
      amount: Stripe.format_currency(raw_refund["amount"]),
      balance_transaction: Stripe.format(raw_refund["balance_transaction"]),
      charge: Stripe.format(raw_refund["charge"]),
      created: Stripe.format_timestamp(raw_refund["created"]),
      currency: raw_refund["currency"],
      failure_balance_transaction: Stripe.format(raw_refund["failure_balance_transaction"]),
      failure_reason: Stripe.format_enum(raw_refund["failure_reason"]),
      metadata: Stripe.format_metadata(raw_refund["metadata"]),
      reason: Stripe.format_enum(raw_refund["reason"]),
      receipt_number: raw_refund["receipt_number"],
      status: Stripe.format_enum(raw_refund["status"]),
    }
  end
end
