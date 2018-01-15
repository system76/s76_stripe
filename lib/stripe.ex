defmodule Stripe do
  # TODO: moduledoc

  @type reference(t) :: nil | String.t | t

  # TODO: must be a supported currency; see https://stripe.com/docs/currencies
  @type currency_code :: String.t

  @type metadata :: %{optional(String.t) => String.t}

  @doc """
  Converts a raw Stripe API response into the equivalent Stripe struct.

  Unix timestamps are converted to `DateTime.t`, integer cents are converted to
  `Decimal.t`, and any enumerated fields are converted to atoms. Other fields
  are mapped as-is.

  Missing and unexpanded references are passed through as-is.
  """
  def format(reference)
  def format(nil), do: nil
  def format(id) when is_binary(id), do: id
  def format(raw_response) do
    module_for(raw_response["object"]).format(raw_response)
  end

  # Core Resources
  # defp module_for("balance")
  defp module_for("balance_transaction"), do: Stripe.BalanceTransaction
  defp module_for("charge"), do: Stripe.Charge
  defp module_for("customer"), do: Stripe.Customer
  # defp module_for("dispute")
  # defp module_for("dispute_evidence")
  defp module_for("event"), do: Stripe.Event
  # defp module_for("file_upload")
  # defp module_for("payout")
  # defp module_for("refund")
  defp module_for("token"), do: Stripe.Token

  # Payment Methods
  # defp module_for("bank_account")
  defp module_for("card"), do: Stripe.Card
  defp module_for("source"), do: Stripe.Source

  @doc false
  def format_currency(cents) do
    Decimal.div(Decimal.new(cents), Decimal.new(100))
  end

  @doc false
  def format_enum(nil), do: nil
  # TODO: uncomment this once I can reliably get the enumerations in the
  # typespecs into the runtime.
  # def format_enum(enum_string), do: String.to_existing_atom(enum_string)
  def format_enum(enum_string), do: String.to_atom(enum_string)

  @doc false
  def format_metadata(metadata), do: metadata

  @doc false
  def format_timestamp(timestamp), do: DateTime.from_unix!(timestamp)
end