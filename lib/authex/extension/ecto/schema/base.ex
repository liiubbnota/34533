defmodule Authex.Extension.Ecto.Schema.Base do
  @moduledoc """
  Used for extensions to extend user schemas.

  ## Usage

      defmodule MyAuthexExtension.Ecto.Schema do
        use Authex.Extension.Ecto.Schema.Base

        def attrs(_config) do
          [{:custom_field, :string}]
        end

        def changeset(changeset, _config) do
          changeset
          |> Ecto.Changeset.validate_required([:custom_field])
        end
      end
  """
  alias Authex.Config
  alias Ecto.Changeset

  @callback validate!(Config.t(), atom()) :: Config.t() | no_return
  @callback attrs(Config.t()) :: [tuple()]
  @callback indexes(Config.t()) :: [tuple()]
  @callback changeset(Changeset.t(), map(), Config.t()) :: Changeset.t()

  defmacro __using__(_opts) do
    quote do
      @behaviour unquote(__MODULE__)

      def validate!(config, _login_field), do: config
      def attrs(_config), do: []
      def changeset(changeset, _attrs, _config), do: changeset
      def indexes(_config), do: []

      defoverridable unquote(__MODULE__)
    end
  end
end