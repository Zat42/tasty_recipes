defmodule TastyRecipes.Recipes.Recipe do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "recipes" do
    field :description, :string
    field :name, :string
    field :owner, :binary_id

    timestamps()
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:name, :description, :owner])
    |> validate_required([:name, :description])
    |> validate_length(:name, min: 2, max: 32)
    |> validate_length(:description, min: 100, max: 1024)
    |> validate_name()
  end

  def validate_name(changeset) do
    name = get_field(changeset, :name)

    case name do
      nil -> changeset
      name ->
        clean_name = String.downcase(name)
        if clean_name =~ "pizza" and clean_name =~ "pineapple" do
          add_error(changeset, :name, "how dare you...")
        else
          changeset
        end
      end
  end
end
