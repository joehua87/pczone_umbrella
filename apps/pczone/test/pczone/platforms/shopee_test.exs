defmodule Pczone.Platforms.ShopeeTest do
  use Pczone.DataCase, async: true
  import Ecto.Query, only: [from: 2]
  import Pczone.Fixtures

  describe "shopee platform" do
    test "read spreadsheet" do
      path = get_fixtures_dir() |> Path.join("mass_update_sales_info.xlsx")

      assert [
               %{
                 product_code: "19301333605",
                 variant_code: "38950760545",
                 variant_name: "i5-6500,16GB + 128GB NVMe"
               },
               %{
                 product_code: "19301333605",
                 variant_code: "38950760546",
                 variant_name: "i5-6500,16GB + 256GB NVMe"
               }
               | _
             ] = Pczone.Platforms.read_product_variants("shopee", path)
    end

    test "upsert simple built variant platforms" do
      result = upsert_simple_built_variant_platforms()

      assert [
               "210076422096",
               "210076422100",
               "38950760549",
               "38950760551",
               "38950760552",
               "38950760553"
             ] = result |> Enum.map(& &1.variant_code) |> Enum.sort()
    end

    test "make pricing workbook" do
      upsert_simple_built_variant_platforms()
      platform = Pczone.Repo.one(from Pczone.Platform, where: [code: "shopee"])
      workbook = Pczone.Platforms.make_pricing_workbook(platform)

      assert %Elixlsx.Workbook{
               datetime: nil,
               sheets: [
                 %Elixlsx.Sheet{
                   col_widths: %{},
                   merge_cells: [],
                   name: "Sheet1",
                   pane_freeze: nil,
                   row_heights: %{},
                   rows: [
                     [
                       "et_title_product_id",
                       "et_title_product_name",
                       "et_title_variation_id",
                       "et_title_variation_name",
                       "et_title_parent_sku",
                       "et_title_variation_sku",
                       "et_title_variation_price",
                       "et_title_variation_stock",
                       "et_title_reason"
                     ],
                     ["sales_info", "220408_floatingstock"],
                     [
                       nil,
                       nil,
                       nil,
                       nil,
                       nil,
                       nil,
                       "Gi?? c???a s???n ph???m ?????t nh???t chia cho gi?? c???a gi???i h???n s???n ph???m r??? nh???t: 5",
                       nil
                     ],
                     [
                       "M?? S???n ph???m",
                       "T??n S???n ph???m",
                       "M?? Ph??n lo???i",
                       "T??n ph??n lo???i",
                       "SKU S???n ph???m",
                       "SKU",
                       "Gi??",
                       "S??? l?????ng"
                     ],
                     ["19301333605" | _],
                     ["19301333605" | _],
                     ["19301333605" | _],
                     ["19301333605" | _],
                     ["19301333605" | _],
                     ["19301333605" | _]
                   ],
                   show_grid_lines: true
                 }
               ]
             } = workbook
    end
  end

  defp upsert_simple_built_variant_platforms() do
    # Initial data
    get_fixtures_dir() |> Pczone.initial_data()
    simple_builts = simple_builts_fixture()
    platform = Pczone.Repo.one(from Pczone.Platform, where: [code: "shopee"])

    # Sync simple built platforms product code
    simple_built_platforms_path =
      get_fixtures_dir() |> Path.join("simple_built_platforms_shopee.xlsx")

    Pczone.Platforms.upsert_simple_built_platforms(platform.id, simple_built_platforms_path)

    # Generate simple built variants
    simple_built = Enum.find(simple_builts, &(&1.code == "hp-elitedesk-800-g2-mini-65w"))
    Pczone.SimpleBuilts.generate_variants(simple_built)

    # Sync simple built variant platforms variant codes
    path = get_fixtures_dir() |> Path.join("mass_update_sales_info.xlsx")

    assert {:ok, {6, result}} =
             Pczone.Platforms.upsert_simple_built_variant_platforms(platform, path,
               returning: true
             )

    result
  end
end
