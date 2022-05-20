defmodule Xeon.Chassis do
  use Ecto.Schema
  import Ecto.Changeset

  @required [:slug, :name, :form_factor, :psu_form_factors, :brand_id]
  @optional []

  schema "chassis" do
    field :slug, :string
    field :name, :string
    field :form_factor, :string
    field :psu_form_factors, {:array, :string}, default: []
    belongs_to :brand, Xeon.Brand
    has_many :products, Xeon.Product
  end

  def changeset(entity, params) do
    entity
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
  end

  def new_changeset(params) do
    %__MODULE__{}
    |> cast(params, @required ++ @optional)
    |> validate_required(@required)
  end
end
