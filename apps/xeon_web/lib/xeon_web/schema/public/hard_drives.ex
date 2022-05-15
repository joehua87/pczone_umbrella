defmodule XeonWeb.Schema.HardDrives do
  use Absinthe.Schema.Notation
  alias Absinthe.Resolution.Helpers

  object :hard_drive do
    field :id, non_null(:id)
    field :name, non_null(:string)

    field :brand,
          :brand,
          resolve: Helpers.dataloader(XeonWeb.Dataloader)
  end
end
