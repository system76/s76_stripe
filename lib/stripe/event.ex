defmodule Stripe.Event do
  @moduledoc """
  The Stripe Event object.

  See https://stripe.com/docs/api/curl#events for further details.
  """

  alias Stripe.Event

  defstruct [
    id: nil,
    api_version: nil,
    created: DateTime.from_unix!(0),
    data: %{object: nil},
    livemode: false,
    pending_webhooks: 0,
    request: nil,
    type: "",
  ]

  @type t :: %Event{
    id: nil | String.t,
    api_version: nil | String.t,
    created: DateTime.t,
    data: %{
      object: any,
      # TODO figure out how to handle keys and nesting
      # previous_attributes: nil | any,
    },
    livemode: boolean,
    pending_webhooks: non_neg_integer,
    # FIXME: Should this be top-level resource? There's doesn't appear to be an
    # endpoint for it.
    request: nil | String.t | %{
      id: nil | String.t,
      idempotency_key: nil | String.t,
    },
    type: String.t,
  }

  # TODO def rertrieve

  # TODO def list

  @doc false
  @spec format(map) :: t
  def format(raw_event) do
    %Event{
      id: raw_event["id"],
      api_version: raw_event["api_version"],
      created: Stripe.format_timestamp(raw_event["created"]),
      data: %{
        object: Stripe.format(get_in(raw_event, ["data", "object"]))
      },
      livemode: raw_event["livemode"],
      pending_webhooks: raw_event["pending_webhooks"],
      request: format_request(raw_event["request"]),
      type: raw_event["type"],
    }
  end

  defp format_request(nil), do: nil
  defp format_request(id) when is_binary(id), do: id
  defp format_request(raw_request) when is_map(raw_request) do
    %{
      id: raw_request["id"],
      idempotency_key: raw_request["idempotency_key"],
    }
  end
end
