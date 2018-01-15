defmodule Stripe.Hook do
  import Logger
  import Plug.Conn

  def init(options) do
    options
  end

  def call(conn, options) do
    [mount: mount, handler: handler] = options

    if mount == "/#{Enum.join(conn.path_info, "/")}" do
      stripe_hook(conn, handler)
    else
      conn
    end
  end

  def stripe_hook(conn, handler) do
    header = conn |> get_req_header("stripe-signature") |> List.first
    {:ok, body, _conn} = read_body(conn)

    secret = case Application.get_env(:s76_stripe, :webhook_secret) do
      {:system, varname} -> System.get_env(varname)
      key -> key
    end

    event = Poison.decode!(body)

    time = get_header_value(header, "t")
    signature = get_header_value(header, "v1")

    # credo:disable-for-lines:3
    hmac =
      :crypto.hmac(:sha256, secret, "#{time}.#{body}")
      |> Base.encode16(case: :lower)

    if Plug.Crypto.secure_compare(hmac, signature) do
      event = Stripe.format(event)

      Logger.info("Received Stripe event of type \"#{event.type}\"", stripe_event: event)
      Logger.debug(fn -> inspect(event) end)

      case handler.(event) do
        :ok ->
          conn
          |> send_resp(204, "")
          |> halt

        {:error, reason} ->
          Logger.error("Error processing Stripe event: #{reason}", stripe_event: event)

          conn
          |> put_resp_content_type("text/plain")
          |> send_resp(400, reason)
          |> halt
      end
    else
      conn
      |> put_resp_content_type("text/plain")
      |> send_resp(401, "Not Authorized")
      |> halt
    end
  end

  # TODO: More defensive coding
  defp get_header_value(header, key) do
    header
    |> String.trim()
    |> String.split(",")
    |> Enum.map(fn (l) -> String.split(l, "=") end)
    |> Enum.filter(fn ([k, _]) -> (k == key) end)
    |> List.first
    |> List.last
  end
end
