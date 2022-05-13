defmodule Xeon.AttributeGroup do
  use Ecto.Schema

  embedded_schema do
    field :title, :string

    embeds_many :items, Attribute do
      field :label, :string
      field :value, :string
    end
  end
end

defmodule Xeon.ProcessorSlot do
  use Ecto.Schema

  embedded_schema do
    field :socket, :string
    field :heatsink, :string
    field :slots, :integer
  end
end

defmodule Xeon.MemorySlot do
  use Ecto.Schema

  embedded_schema do
    field :max_capacity, :integer
    field :types, {:array, :string}
    field :slots, :integer
  end
end

defmodule Xeon.SataSlot do
  use Ecto.Schema

  embedded_schema do
    field :types, {:array, :string}
    field :slots, :integer
  end
end

defmodule Xeon.M2Slot do
  use Ecto.Schema

  embedded_schema do
    field :types, {:array, :string}
    field :slots, :integer
  end
end

defmodule Xeon.PciSlot do
  use Ecto.Schema

  embedded_schema do
    field :types, {:array, :string}
    field :slots, :integer
  end
end
