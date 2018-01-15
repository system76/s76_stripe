defmodule Stripe.Error do
  defexception [:type, :charge, :message, :code, :decline_code, :param]

  @type t :: %__MODULE__{
    type: type,
    charge: String.t,
    message: nil | String.t,
    code: nil | String.t,
    decline_code: nil | String.t,
    param: nil | atom,
  }

  @type type :: :api_connection_error | :api_error | :authentication_error |
                :card_error | :idempotency_error | :invalid_request_error |
                :rate_limit_error
end
