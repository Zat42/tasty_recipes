defmodule TastyRecipes.BotConsumer do
  use Nostrum.Consumer

  import Ecto.Query, warn: false

  alias Nostrum.Api

  alias TastyRecipes.Accounts.User
  alias TastyRecipes.Recipes
  alias TastyRecipes.Recipes.Recipe
  alias TastyRecipes.Repo

  alias TastyRecipesWeb.Router.Helpers, as: Routes
  alias TastyRecipesWeb.Endpoint

  require Logger

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    command = List.first(String.split(msg.content))

    case command do
      "!count" -> count_recipes(msg)
      "!last_recipe" -> last_recipe(msg)
      "!recipes" -> recipes_matching(msg)
      _ -> :ignore
    end
  end

  # Default event handler, if you don't include this, your consumer WILL crash if
  # you don't have a method definition for each event type.
  def handle_event(_event) do
    :noop
  end

  def count_recipes(msg) do
    count = length(Recipes.list_recipes())

    Api.create_message(
      msg.channel_id,
      "There is actually #{count} #{Inflex.inflect("recipe", count)} on the website!"
    )
  end

  def last_recipe(msg) do
    # Extract email from message
    try do
      args = List.to_tuple(String.split(msg.content))
      email = elem(args, 1)

      # Get the last recipe, nil if no result found
      recipe =
        Recipe
        |> join(:left, [r], u in User, on: r.owner == u.id)
        |> where([r, u], u.email == ^email)
        |> order_by([r, u], desc: r.inserted_at)
        |> limit(1)
        |> Repo.all()
        |> List.first()

      last_recipe_message(msg.channel_id, recipe, email)
    rescue
      ArgumentError ->
        Api.create_message(
          msg.channel_id,
          ":warning: That's not how you should use it..."
        )
    end
  end

  def last_recipe_message(channel_id, %Recipe{} = recipe, email) do
    show_url = Routes.html_recipe_show_url(Endpoint, :show, recipe.id)

    Api.create_message(
      channel_id,
      ":white_check_mark: Last recipe for **#{email}** is **#{recipe.name}**!\nCheck it there : #{show_url}"
    )
  end

  def last_recipe_message(channel_id, nil = _recipe, _email) do
    Api.create_message(
      channel_id,
      ":question: No recipe found for this user, sorry."
    )
  end

  def recipes_matching(msg) do
    try do
      args = List.to_tuple(String.split(msg.content))
      email = elem(args, 1)
      search = elem(args, 2)

      recipes =
        Recipe
        |> Recipe.with_owner_email(email)
        |> Recipe.name_contains(search)
        |> order_by([r, u], desc: r.inserted_at)
        |> Repo.all()

      recipes_matching_message(msg.channel_id, recipes, email, search)
    rescue
      ArgumentError ->
        Api.create_message(
          msg.channel_id,
          ":warning: That's not how you should use it..."
        )
    end
  end

  def recipes_matching_message(channel_id, [] = _recipes, _email, _search) do
    Api.create_message(
      channel_id,
      ":question: No recipe found, sorry."
    )
  end

  def recipes_matching_message(channel_id, recipes, email, search) do
    message = ":white_check_mark: Recipes containing \"**#{search}**\" for **#{email}** found:\n\n"
    list = for recipe <- recipes do
      "・ " <>
      recipe.name <>
      " - " <>
      Routes.html_recipe_show_url(Endpoint, :show, recipe.id) <>
      "\n"
    end

    Api.create_message(
      channel_id,
      "#{message} #{list}"
    )
  end

end
