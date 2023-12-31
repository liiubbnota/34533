defmodule PowEmailConfirmation.Phoenix.Mailer do
  @moduledoc false
  alias Plug.Conn
  alias Pow.Phoenix.Mailer.Mail
  alias PowEmailConfirmation.Phoenix.Mail, as: EmailConfirmationMail

  @spec email_confirmation(Conn.t(), map(), binary()) :: Mail.t()
  def email_confirmation(conn, user, url) do
    Mail.new(conn, user, {EmailConfirmationMail, :email_confirmation}, url: url)
  end
end
