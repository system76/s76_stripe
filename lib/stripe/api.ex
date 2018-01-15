defmodule Stripe.API do
  # NOTE: this is written against version 2015-04-07 of the Stripe API

  use HTTPoison.Base

  @endpoint "https://api.stripe.com/v1/"

  # TODO: convert to Stripe.Error.t
  @type response(t) :: {:ok, t} | {:error, HTTPoison.Error.t}

  defp process_url(url) do
    @endpoint <> url
  end

  defp process_request_headers(headers) do
    key = Application.get_env(:hal, :stripe)[:key]
    auth_string = Base.encode64("#{key}:")
    hal_version = Application.spec(:hal, :vsn)

    [
      {"Authorization", "Basic #{auth_string}"},
      {"User-Agent", "Stripe/v1 Hal/#{hal_version}"},
      # {"Content-Type", "application/json"},
    ] ++ headers
  end

  defp process_request_body(body) when is_binary(body), do: body
  defp process_request_body(params) when is_map(params), do: {:form, format_params(params)}
  defp process_request_body(params) when is_list(params), do: {:form, params}

  defp process_response_body(body) do
    Poison.decode! body
  end

  # TODO: normalize errors
  def format_response({:ok, raw_response}),
    do: {:ok, Stripe.format(raw_response.body)}
  def format_response(error),
    do: error

  defp format_params(params_map) do
    Enum.flat_map(params_map, fn {key, item} ->
      do_format_params("#{key}", item)
    end)
  end

  # assume that all decimals are money and convert to integer cents
  defp do_format_params(prefix, %Decimal{} = item_map) do
    cents =
      item_map
      |> Decimal.mult(Decimal.new(100))
      |> Decimal.to_integer()

    [{prefix, cents}]
  end
  defp do_format_params(prefix, item_map) when is_map(item_map) do
    Enum.flat_map(item_map, fn {key, item} ->
      do_format_params("#{prefix}[#{key}]", item)
    end)
  end
  defp do_format_params(prefix, item_list) when is_list(item_list) do
    Enum.flat_map(item_list, fn item ->
      do_format_params("#{prefix}[]", item)
    end)
  end
  defp do_format_params(prefix, item) do
    [{prefix, item}]
  end
end
