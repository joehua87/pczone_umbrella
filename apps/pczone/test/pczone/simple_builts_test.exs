defmodule Pczone.SimpleBuiltsTest do
  use Pczone.DataCase
  import Ecto.Query, only: [from: 2]
  import Pczone.Fixtures
  alias Pczone.{Repo, SimpleBuilts}

  describe "simple builts" do
    test "upsert" do
      list = Pczone.Fixtures.read_fixture("simple_builts.yml")
      {:ok, [%Pczone.SimpleBuilt{} | _]} = Pczone.SimpleBuilts.upsert(list)

      assert %{
               processors: [
                 %{processor_label: "i3-9100", gpu_label: ""},
                 %{processor_label: "i3-9100F", gpu_label: "K600", gpu: %{}, gpu_product: %{}}
               ]
             } =
               Repo.one(
                 from Pczone.SimpleBuilt,
                   preload: [:processors],
                   where: [code: "dell-optiplex-7060-sff"]
               )
    end

    test "remove simple built processors" do
      list = Pczone.Fixtures.read_fixture("simple_builts.yml")
      {:ok, [%Pczone.SimpleBuilt{id: simple_built_id} | _]} = Pczone.SimpleBuilts.upsert(list)
      Pczone.SimpleBuilts.remove_simple_built_processors(simple_built_id)

      assert %{processors: []} =
               Repo.get(from(Pczone.SimpleBuilt, preload: [:processors]), simple_built_id)
    end

    test "remove simple built memories" do
      list = Pczone.Fixtures.read_fixture("simple_builts.yml")
      {:ok, [%Pczone.SimpleBuilt{id: simple_built_id} | _]} = Pczone.SimpleBuilts.upsert(list)
      Pczone.SimpleBuilts.remove_simple_built_memories(simple_built_id)

      assert %{memories: []} =
               Repo.get(from(Pczone.SimpleBuilt, preload: [:memories]), simple_built_id)
    end

    test "remove simple built hard_drives" do
      list = Pczone.Fixtures.read_fixture("simple_builts.yml")
      {:ok, [%Pczone.SimpleBuilt{id: simple_built_id} | _]} = Pczone.SimpleBuilts.upsert(list)
      Pczone.SimpleBuilts.remove_simple_built_hard_drives(simple_built_id)

      assert %{hard_drives: []} =
               Repo.get(from(Pczone.SimpleBuilt, preload: [:hard_drives]), simple_built_id)
    end

    test "generate simple built variants" do
      [simple_built | _] = simple_builts_fixture()

      [
        %{
          barebone_price: 1_800_000,
          gpu_amount: 0,
          gpu_price: 0,
          gpu_quantity: 0,
          hard_drive_amount: 0,
          hard_drive_price: 0,
          hard_drive_quantity: 0,
          memory_amount: 0,
          memory_price: 0,
          memory_quantity: 0,
          option_values: ["i5-6500T", "Ko RAM + Ko SSD"],
          position: 0,
          processor_amount: 1_700_000,
          processor_price: 1_700_000,
          processor_quantity: 1,
          total: 3_500_000,
          name: "i5-6500T,Ko RAM + Ko SSD"
        }
        | _
      ] =
        simple_built_variants =
        SimpleBuilts.generate_variants(simple_built)
        |> Enum.sort(&(&1.position < &2.position))

      assert length(simple_built_variants) ==
               length(simple_built.processors) *
                 (length(simple_built.memories) + 1) *
                 (length(simple_built.hard_drives) + 1)
    end

    test "upsert generated simple built variants" do
      [simple_built | _] = simple_builts_fixture()

      assert {:ok,
              {_,
               [
                 %{
                   barebone_price: 1_800_000,
                   gpu_amount: 0,
                   gpu_price: 0,
                   gpu_quantity: 0,
                   hard_drive_amount: 0,
                   hard_drive_price: 0,
                   hard_drive_quantity: 0,
                   memory_amount: 0,
                   memory_price: 0,
                   memory_quantity: 0,
                   option_values: ["i5-6500T", "Ko RAM + Ko SSD"],
                   processor_amount: 1_700_000,
                   processor_price: 1_700_000,
                   processor_quantity: 1,
                   total: 3_500_000
                 }
                 | _
               ]}} =
               simple_built
               |> SimpleBuilts.generate_variants()
               |> SimpleBuilts.upsert_variants(returning: true)
    end

    test "generate content" do
      [simple_built | _] = simple_builts_fixture()

      assert {:ok, {_, _}} =
               simple_built
               |> SimpleBuilts.generate_variants()
               |> SimpleBuilts.upsert_variants()

      template = """
      {{name}}
      {{#variants}}
      * {{option_values}}: {{total}}
      {{/variants}}
      """

      # TODO: Findout when string is not equal even if look like equal
      assert """
             Hp Elitedesk 800 G2 Mini
             """ <> _ = SimpleBuilts.generate_content(simple_built.id, template)
    end
  end

  setup do
    get_fixtures_dir()
    |> Pczone.initial_data()

    :ok
  end
end
