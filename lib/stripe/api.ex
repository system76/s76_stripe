defmodule Stripe.API do
  @moduledoc false

  use HTTPoison.Base

  @endpoint "https://api.stripe.com/v1/"

  # TODO: convert to Stripe.Error.t
  @type response(t) :: {:ok, t} | {:error, HTTPoison.Error.t}

  def process_url(url) do
    @endpoint <> url
  end

  def process_request_headers(headers) do
    key = case Application.get_env(:s76_stripe, :secret_key) do
      {:system, varname} -> System.get_env(varname)
      key -> key
    end

    auth_string = Base.encode64("#{key}:")
    app_version = Application.spec(:s76_stripe, :vsn)

    [
      {"Authorization", "Basic #{auth_string}"},
      {"User-Agent", "Stripe/v1 S76Stripe/#{app_version}"},
    ] ++ headers
  end

  def process_request_body(body) when is_binary(body), do: body
  def process_request_body(params) when is_map(params), do: {:form, format_params(params)}
  def process_request_body(params) when is_list(params), do: {:form, params}
  def process_response_body(body), do: Poison.decode!(body)

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
