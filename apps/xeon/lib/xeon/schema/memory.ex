defmodule Xeon.Memory do
  use Ecto.Schema

  schema "memory" do
    field :name, :string
    field :capacity, :integer
    field :type, :string
    belongs_to :brand, Xeon.Brand
    has_many :products, Xeon.Product
  end
end
