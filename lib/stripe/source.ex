defmodule Stripe.Source do
  @moduledoc """
  The Stripe Source object.

  See https://stripe.com/docs/api/curl#sources for further details.
  """

  alias Stripe.{API, Card, Source}

  @endpoint "sources"

  defstruct [
    id: nil,
    amount: Decimal.new(0),
    client_secret: "",
    # code_verification: nil
    created: DateTime.from_unix!(0),
    currency: "usd",
    flow: :none,
    livemode: false,
    metadata: %{},
    statement_descriptor: nil,
    status: :pending,
    type: :card,
    usage: :reusable,
  ]

  @type t :: %Source{
    id: nil | String.t,
    amount: Decimal.t,
    client_secret: String.t,
    # code_verification: nil | %{
    #   attempts_remaining: non_neg_integer,
    #   status: :pending | :succeeded | :failed,
    # },
    created: DateTime.t,
    currency: Stripe.currency_code,
    flow: :redirect | :receiver | :code_verification | :none,
    livemode: boolean,
    metadata: Stripe.metadata,
    # owner: nil | TODO
    # receiver: nil | %{
    #   address: String.t,
    #   amount_charged: Decimal.t,
    #   amount_received: Decimal.t,
    #   amount_returned: Decimal.t,
    # },
    # redirect: nil | %{
    #   failure_reason: nil | :user_abort | :declined | :processing_error,
    #   return_url: String.t,
    #   status: :pending | :succeeded | :failed | :not_required,
    #   url: String.t,
    # },
    statement_descriptor: nil | String.t,
    status: :canceled | :chargeable | :consumed | :failed | :pending,
    type: atom, # Stripe's list of types is incomplete in their documentation
                # and grows frequently.
    usage: :reusable | :single_use,
  }

  # TODO def create

  # TODO def retrieve

  # TODO def update

  @spec attach(String.t, String.t) :: API.response(t | Card.t)
  def attach(customer_id, source_id) do
    "customers/#{customer_id}/sources"
    |> API.post(%{source: source_id})
    |> API.format_response()
  end

  @spec detach(String.t, String.t) :: API.response(t | Card.t)
  def detach(customer_id, source_id) do
    "customers/#{customer_id}/sources/#{source_id}"
    |> API.delete()
    |> API.format_response()
  end

  @doc false
  def format(raw_source) do
    %Source{
      id: raw_source["id"],
      amount: Stripe.format_currency(raw_source["amount"]),
      client_secret: raw_source["client_secret"],
      created: Stripe.format_timestamp(raw_source["created"]),
      currency: raw_source["currency"],
      flow: Stripe.format_enum(raw_source["flow"]),
      livemode: raw_source["livemode"],
      metadata: Stripe.format_metadata(raw_source["metadata"]),
      statement_descriptor: raw_source["statement_descriptor"],
      status: Stripe.format_enum(raw_source["status"]),

      # TODO: find a solution here that doesn't risk a memory leak
      type: String.to_atom(raw_source["type"]),

      usage: Stripe.format_enum(raw_source["usage"]),
    }
  end
end
