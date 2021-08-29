defmodule TastyRecipesWeb.Html.RecipeLiveTest do
  use TastyRecipesWeb.ConnCase

  import Phoenix.LiveViewTest

  alias TastyRecipes.Recipes

  @create_attrs %{description: "some description", name: "some name"}
  @update_attrs %{description: "some updated description", name: "some updated name"}
  @invalid_attrs %{description: nil, name: nil}

  defp fixture(:recipe) do
    {:ok, recipe} = Recipes.create_recipe(@create_attrs)
    recipe
  end

  defp create_recipe(_) do
    recipe = fixture(:recipe)
    %{recipe: recipe}
  end

  describe "Index" do
    setup [:create_recipe]

    test "lists all recipes", %{conn: conn, recipe: recipe} do
      {:ok, _index_live, html} = live(conn, Routes.recipe_index_path(conn, :index))

      assert html =~ "Listing Recipes"
      assert html =~ recipe.description
    end

    test "saves new recipe", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.recipe_index_path(conn, :index))

      assert index_live |> element("a", "New Recipe") |> render_click() =~
               "New Recipe"

      assert_patch(index_live, Routes.recipe_index_path(conn, :new))

      assert index_live
             |> form("#recipe-form", recipe: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#recipe-form", recipe: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.recipe_index_path(conn, :index))

      assert html =~ "Recipe created successfully"
      assert html =~ "some description"
    end

    test "updates recipe in listing", %{conn: conn, recipe: recipe} do
      {:ok, index_live, _html} = live(conn, Routes.recipe_index_path(conn, :index))

      assert index_live |> element("#recipe-#{recipe.id} a", "Edit") |> render_click() =~
               "Edit Recipe"

      assert_patch(index_live, Routes.recipe_index_path(conn, :edit, recipe))

      assert index_live
             |> form("#recipe-form", recipe: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#recipe-form", recipe: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.recipe_index_path(conn, :index))

      assert html =~ "Recipe updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes recipe in listing", %{conn: conn, recipe: recipe} do
      {:ok, index_live, _html} = live(conn, Routes.recipe_index_path(conn, :index))

      assert index_live |> element("#recipe-#{recipe.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#recipe-#{recipe.id}")
    end
  end

  describe "Show" do
    setup [:create_recipe]

    test "displays recipe", %{conn: conn, recipe: recipe} do
      {:ok, _show_live, html} = live(conn, Routes.html_recipe_show_path(conn, :show, recipe))

      assert html =~ "Show Recipe"
      assert html =~ recipe.description
    end

    test "updates recipe within modal", %{conn: conn, recipe: recipe} do
      {:ok, show_live, _html} = live(conn, Routes.html_recipe_show_path(conn, :show, recipe))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Recipe"

      assert_patch(show_live, Routes.html_recipe_show_path(conn, :edit, recipe))

      assert show_live
             |> form("#recipe-form", recipe: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#recipe-form", recipe: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.html_recipe_show_path(conn, :show, recipe))

      assert html =~ "Recipe updated successfully"
      assert html =~ "some updated description"
    end
  end
end
