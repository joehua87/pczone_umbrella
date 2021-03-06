defmodule Pczone.ExtensionDevicesTest do
  use Pczone.DataCase
  alias Pczone.ExtensionDevices

  describe "extension devices" do
    test "parse data for upsert", %{brands_map: brands_map} do
      [params | _] = Pczone.Fixtures.read_fixture("extension_devices.yml")

      assert %{
               brand_id: _,
               code: "pcie-to-m2",
               m2_slots: [
                 %Pczone.M2Slot{
                   form_factors: ["m2 2280"],
                   quantity: 1,
                   supported_types: ["nvme pcie 3.0 x4"],
                   type: "nvme pcie 3.0 x4"
                 }
               ],
               name: "PCI-e to M2",
               slug: "pci-e-to-m2",
               type: "pcie 3.0 x4"
             } = ExtensionDevices.parse_entity_for_upsert(params, brands_map: brands_map)
    end

    test "upsert" do
      entities = Pczone.Fixtures.read_fixture("extension_devices.yml")

      assert {:ok,
              {1,
               [
                 %{
                   brand_id: _,
                   code: "pcie-to-m2",
                   m2_slots: [
                     %Pczone.M2Slot{
                       form_factors: ["m2 2280"],
                       quantity: 1,
                       supported_types: ["nvme pcie 3.0 x4"],
                       type: "nvme pcie 3.0 x4"
                     }
                   ],
                   name: "PCI-e to M2",
                   slug: "pci-e-to-m2",
                   type: "pcie 3.0 x4"
                 }
                 | _
               ]}} = ExtensionDevices.upsert(entities, returning: true)

      # assert {5,
      #         [
      #           %Pczone.ExtensionDevice{
      #             brand_id: _,
      #             form_factor: "sff",
      #             id: _,
      #             name: "Dell OptiPlex 7040 SFF",
      #             wattage: 180
      #           }
      #           | _
      #         ]} = ExtensionDevices.upsert(entities, returning: true)
    end
  end

  setup do
    "brands.yml" |> Pczone.Fixtures.read_fixture() |> Pczone.Brands.upsert()
    brands_map = Pczone.Brands.get_map_by_slug()
    {:ok, brands_map: brands_map}
  end
end
