defmodule Xeon.Brand do
  use Ecto.Schema
  import Ecto.Changeset

  @derive Jason.Encoder

  @required [:slug, :name]
  @optional []

  schema "brand" do
    field :slug, :string, null: false
    field :name, :string, null: false
  end

  def changeset(entity, params) do
    entity
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
  end

  def new_changeset(params) do
    changeset(%__MODULE__{}, params)
  end
end
