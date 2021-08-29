defmodule TastyRecipes.Repo do
  use Ecto.Repo,
    otp_app: :tasty_recipes,
    adapter: Ecto.Adapters.Postgres
end
