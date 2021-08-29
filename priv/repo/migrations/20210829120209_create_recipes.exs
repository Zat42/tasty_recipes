defmodule TastyRecipes.Repo.Migrations.CreateRecipes do
  use Ecto.Migration

  def change do
    create table(:recipes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :text
      add :owner, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:recipes, [:owner])
  end
end
