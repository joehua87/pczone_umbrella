defmodule PcZone.BuiltMemory do
  use Ecto.Schema
  import Ecto.Changeset

  @required [
    :built_id,
    :memory_id,
    :product_id,
    :slot_type,
    :processor_index,
    :price,
    :quantity,
    :total
  ]
  @optional [:extension_device_id]

  schema "built_memory" do
    belongs_to :built, PcZone.Built
    belongs_to :memory, PcZone.Memory
    belongs_to :product, PcZone.Product
    belongs_to :extension_device, PcZone.ExtensionDevice
    field :slot_type, :string
    field :processor_index, :integer
    field :price, :integer
    field :quantity, :integer
    field :total, :integer
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