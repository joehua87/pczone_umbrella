defmodule Pczone.SimpleBuiltHardDrive do
  use Ecto.Schema
  import Ecto.Changeset

  @derive Jason.Encoder

  @required [:key, :simple_built_id, :hard_drive_id, :hard_drive_product_id]
  @optional [:quantity, :label]

  schema "simple_built_hard_drive" do
    field :key, :string
    belongs_to :simple_built, Pczone.SimpleBuilt
    belongs_to :hard_drive, Pczone.HardDrive
    belongs_to :hard_drive_product, Pczone.Product
    field :quantity, :integer, default: 1
    field :label, :string
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
