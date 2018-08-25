defmodule Pow.Phoenix.Mailer do
  @moduledoc """
  This module provides an API for mails to be sent by Pow.

  Pow mails is build with `Pow.Phoenix.Mailer.Mail` structs, and consists of
  `:subject`, `:text`, `:html` and `:user` keys.

  ## Usage

      defmodule MyAppWeb.Pow.Mailer do
        use Pow.Phoenix.Mailer
        require Logger

        def cast(%{user: user, subject: subject, text: text, html: html}) do
          # Build email struct to be used in `process/1`

          %{to: user.email, subject: subject, text: text, html: html}
        end

        def process(email) do
          # Send email

          Logger.debug("E-mail sent: \#{inspect email}")
        end
      end

    Remember to update configuration with `mailer_backend: MyAppWeb.Pow.Mailer`
  """
  alias Plug.Conn
  alias Pow.Phoenix.Mailer.Mail

  @callback cast(Mail.t()) :: any()
  @callback process(any()) :: any()

  defmacro __using__(_opts) do
    quote do
      @behaviour unquote(__MODULE__)
    end
  end

  @spec deliver(Conn.t(), Mail.t()) :: any()
  def deliver(conn, email) do
    config = Pow.Plug.fetch_config(conn)
    mailer = Pow.Config.get(config, :mailer_backend, nil) || raise_no_mailer_backend_set()

    email
    |> mailer.cast()
    |> mailer.process()
  end

  @spec raise_no_mailer_backend_set :: no_return
  defp raise_no_mailer_backend_set do
    Pow.Config.raise_error("No :mailer_backend configuration option found for plug.")
  end
end
