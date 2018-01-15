defmodule Stripe.Charge do
  @moduledoc """
  The Stripe Charge object.

  See https://stripe.com/docs/api/curl#charges for further details.
  """

  alias Stripe.{API, BalanceTransaction, Charge}

  @endpoint "charges"

  defstruct [
    id: nil,
    amount: 0,
    amount_refunded: 0,
    application_fee: nil,
    balance_transaction: nil,
    captured: false,
    created: DateTime.from_unix!(0),
    currency: "usd",
    description: nil,
    dispute: nil,
    failure_code: nil,
    failure_message: nil,
    fraud_details: nil,
    invoice: nil,
    livemode: false,
    metadata: %{},
    outcome: nil,
    paid: false,
    receipt_email: nil,
    receipt_number: nil,
    refunded: false,
    review: nil,
    shipping: nil,
    statement_descriptor: nil,
    status: :pending,
  ]

  @type t :: %Charge{
    id: nil | String.t,
    amount: Decimal.t,
    amount_refunded: Decimal.t,
    # application: nil | String.t,
    application_fee: nil | String.t,
    balance_transaction: Stripe.reference(BalanceTransaction.t),
    captured: boolean,
    created: DateTime.t,
    currency: Stripe.currency_code,
    # customer: Stripe.reference(Customer.t),
    description: nil | String.t,
    # destination: nil | String.t,
    dispute: nil | String.t, # Stripe.reference(Stripe.Dispute.t),
    failure_code: nil | String.t, # TODO see https://stripe.com/docs/api#errors for list
    failure_message: nil | String.t,
    fraud_details: nil | %{
      optional(:user_report) => :safe | :fraudulent,
      optional(:stripe_report) => :fraudulent,
    },
    invoice: nil | String.t, # Stripe.reference(Stripe.Invoice.t),
    livemode: boolean,
    metadata: Stripe.metadata,
    # on_behalf_of: Stripe.reference(Stripe.Account.t),
    # order: Stripe.reference(Stripe.Order.t),
    outcome: nil | %{
      network_status: :approved_by_network | :declined_by_network |
                      :not_sent_to_network | :reversed_after_approval,
      reason: String.t,
      risk_level: :normal | :elevated | :highest,
      seller_message: String.t,
      type: :authorized | :manual_review | :issuer_declined | :blocked |
            :invalid,
    },
    paid: boolean,
    receipt_email: nil | String.t,
    receipt_number: nil | String.t,
    refunded: boolean,
    # refunds: [map], # TODO refund fields
    review: nil | String.t, # Stripe.reference(Stripe.Review.t),
    shipping: nil | %{
      address: %{
        city: nil | String.t,
        country: nil | String.t,
        line1: nil | String.t,
        line2: nil | String.t,
        postal_code: nil | String.t,
        state: nil | String.t,
      },
      carrier: String.t,
      name: String.t,
      phone: String.t,
      tracking_number: String.t,
    },
    # source: Stripe.reference(Stripe.Source.t),
    # source_transfer
    statement_descriptor: nil | String.t,
    status: :pending | :succeeded | :failed,
    # transfer
    # transfer_group
  }

  @doc "See https://stripe.com/docs/api/curl#create_charge"
  @spec create(map) :: API.response(t)
  def create(params) do
    @endpoint |> API.post(params) |> API.format_response()
  end

  # TODO def retrieve(id)

  # TODO def update(charge, params)

  @doc "See https://stripe.com/docs/api/curl#capture_charge"
  @spec capture(map) :: API.response(t)
  def capture(id_or_charge) do
    id = if is_map(id_or_charge), do: id_or_charge.id, else: id_or_charge
    "#{@endpoint}/#{id}/capture" |> API.post(%{}) |> API.format_response()
  end

  # TODO def list

  @doc false
  @spec format(map) :: t
  def format(raw_charge) do
    %Charge{
      id: raw_charge["id"],
      amount: Stripe.format_currency(raw_charge["amount"]),
      amount_refunded: Stripe.format_currency(raw_charge["amount_refunded"]),
      application_fee: raw_charge["application_fee"],
      balance_transaction: Stripe.format(raw_charge["balance_transaction"]),
      captured: raw_charge["captured"],
      created: Stripe.format_timestamp(raw_charge["created"]),
      currency: raw_charge["currency"],
      description: raw_charge["description"],
      dispute: raw_charge["dispute"],
      failure_code: raw_charge["failure_code"],
      failure_message: raw_charge["failure_message"],
      fraud_details: format_fraud_details(raw_charge["fraud_details"]),
      invoice: nil, # TODO Invoice.format(raw_charge["invoice"]),
      livemode: raw_charge["livemode"],
      metadata: Stripe.format_metadata(raw_charge["metadata"]),
      outcome: format_outcome(raw_charge["outcome"]),
      paid: raw_charge["paid"],
      receipt_email: raw_charge["receipt_email"],
      receipt_number: raw_charge["receipt_number"],
      refunded: raw_charge["refunded"],
      review: nil, # TODO: Review.format(raw_charge["review"]),
      shipping: format_shipping(raw_charge["shipping"]),
      statement_descriptor: raw_charge["statement_descriptor"],
      status: Stripe.format_enum(raw_charge["status"]),
    }
  end

  defp format_fraud_details(nil), do: nil
  defp format_fraud_details(raw_details) do
    details = %{}

    details =
      if Map.has_key?(raw_details, "user_report") do
        Map.put(details, :user_report, Stripe.format_enum(raw_details["user_report"]))
      else
        details
      end

    details =
      if Map.has_key?(raw_details, "stripe_report") do
        Map.put(details, :stripe_report, Stripe.format_enum(raw_details["stripe_report"]))
      else
        details
      end

    details
  end

  defp format_outcome(nil), do: nil
  defp format_outcome(raw_outcome) do
    %{
      network_status: Stripe.format_enum(raw_outcome["network_status"]),
      reason: raw_outcome["reason"],
      risk_level: Stripe.format_enum(raw_outcome["risk_level"]),
      seller_message: raw_outcome["seller_message"],
      type: Stripe.format_enum(raw_outcome["type"]),
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
      carrier: raw_shipping["carrier"],
      name: raw_shipping["name"],
      phone: raw_shipping["phone"],
      tracking_number: raw_shipping["tracking_number"],
    }
  end
end
