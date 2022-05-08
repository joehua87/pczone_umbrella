defmodule Xeon.Repo.Migrations.Initialize do
  use Ecto.Migration

  def change do
    create table(:brand) do
      add :name, :string, null: false
    end

    create table(:chipset) do
      add :shortname, :string, null: false
      add :code_name, :string, null: false
      add :name, :string, null: false
      add :launch_date, :string, null: false
      add :collection_name, :string, null: false
      add :vertical_segment, :string, null: false
      add :status, :string, null: false
      add :attributes, :map, null: false
    end

    create unique_index(:chipset, [:shortname])

    create table(:motherboard_type) do
      add :name, :string, null: false
    end

    create table(:motherboard) do
      add :name, :string, null: false
      add :max_memory_capacity, :integer, null: false
      add :memory_slots, :integer, null: false
      add :memory_types, {:array, :string}, null: false
      add :processor_slots, :integer, null: false, default: 1
      add :hard_drive_slots, :map, null: false
      add :pci_slots, :map, null: false
      add :form_factor, :string
      add :chipset_id, references(:chipset), null: false
      add :brand_id, references(:brand)
      add :attributes, :map, null: false
      add :note, :string
    end

    create unique_index(:motherboard, [:name])

    create table(:barebone) do
      add :name, :string, null: false
      add :motherboard_id, references(:motherboard), null: false
      add :hard_drive_slots, :map, null: false
      add :wattage, :integer, null: false
      add :form_factor, :string
      add :attributes, :map, null: false
    end

    create table(:processor_collection) do
      add :name, :string, null: false
      add :code, :string
      add :socket, :string
    end

    create unique_index(:processor_collection, [:name])

    create table(:processor) do
      add :code, :string, null: false
      add :name, :string, null: false
      add :sub, :string, null: false
      add :collection_id, references(:processor_collection)
      add :collection_name, :string, null: false
      add :launch_date, :string, null: false
      add :status, :string, null: false
      add :vertical_segment, :string, null: false
      add :socket, :string
      add :case_temperature, :decimal
      add :lithography, :string
      add :base_frequency, :decimal
      add :tdp_up_base_frequency, :decimal
      add :tdp_down_base_frequency, :decimal
      add :max_turbo_frequency, :decimal
      add :tdp, :decimal
      add :tdp_up, :decimal
      add :tdp_down, :decimal
      add :cache_size, :decimal, null: false
      add :cores, :integer, null: false
      add :threads, :integer
      add :processor_graphics, :string
      add :url, :string, null: false
      add :memory_types, {:array, :string}, null: false
      add :ecc_memory_supported, :boolean, default: false
      add :meta, :map
      add :attributes, :map, default: "[]"
    end

    create unique_index(:processor, [:name, :sub])

    create table(:processor_chipset) do
      add :processor_id, references(:processor), null: false
      add :chipset_id, references(:chipset), null: false
    end

    create unique_index(:processor_chipset, [:processor_id, :chipset_id])

    create table(:processor_score) do
      add :processor_id, references(:processor), null: false
      add :test_name, :string, null: false
      add :single, :integer, null: false
      add :multi, :integer, null: false
    end

    create unique_index(:processor_score, [:processor_id, :test_name])

    create table(:memory) do
      add :name, :string, null: false
      add :type, :string, null: false
      add :capacity, :integer, null: false
      add :tdp, :integer
      add :brand_id, references(:brand)
    end

    create table(:motherboard_processor_collection) do
      add :motherboard_id, references(:motherboard), null: false
      add :processor_collection_id, references(:processor_collection), null: false
    end

    create table(:hard_drive) do
      add :name, :string, null: false
      add :type, :string, null: false
      add :capacity, :integer, null: false
      add :tdp, :integer
      add :brand_id, references(:brand)
    end

    create table(:gpu) do
      add :name, :string, null: false
      add :memory_capacity, :integer, null: false
      add :form_factors, {:array, :string}, null: false
      add :tdp, :integer
      add :brand_id, references(:brand)
    end

    create table(:chassis) do
      add :name, :string, null: false
      add :form_factor, :string
      add :psu_form_factors, {:array, :string}, null: false
      add :brand_id, references(:brand)
    end

    create table(:psu) do
      add :name, :string, null: false
      add :wattage, :integer, null: false
      add :form_factor, :string
      add :brand_id, references(:brand)
    end

    create table(:hard_drive_extension_device) do
      add :name, :string, null: false
      add :hard_drive_slots, :map, null: false
    end

    create table(:product_category) do
      add :slug, :string, null: false
      add :title, :string, null: false
    end

    create table(:product) do
      add :slug, :string, null: false
      add :title, :string, null: false
      add :description, :string
      add :condition, :string, null: false
      add :list_price, :decimal, null: false
      add :sale_price, :decimal, null: false
      add :percentage_off, :decimal, null: false
      add :type, :string
      add :category, references(:product_category)
      add :keywords, {:array, :string}, default: [], null: false
      add :barebone_id, references(:barebone)
      add :motherboard_id, references(:motherboard)
      add :processor_id, references(:processor)
      add :hard_drive_id, references(:hard_drive)
      add :memory_id, references(:memory)
      add :gpu_id, references(:gpu)
      add :chassis_id, references(:chassis)
      add :psu_id, references(:psu)
      add :hard_drive_extension_device_id, references(:hard_drive_extension_device)
    end

    create table(:built) do
      add :barebone_id, references(:barebone)
      add :motherboard_id, references(:motherboard)
      add :total, :decimal
    end

    create table(:built_product) do
      add :built_id, references(:built), null: false
      add :product_id, references(:product), null: false
      add :quantity, :integer
      add :price, :decimal, null: false
      add :amount, :decimal, null: false
    end
  end
end
