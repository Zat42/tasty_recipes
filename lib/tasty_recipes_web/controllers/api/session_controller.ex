defmodule TastyRecipesWeb.Api.SessionController do
  use TastyRecipesWeb, :controller

  alias TastyRecipes.Accounts
  alias TastyRecipes.Accounts.User

  alias TastyRecipes.Guardian

  def create(conn, %{"email" => nil}) do
    conn
    |> put_status(401)
    |> render("error.json", message: "Wrong credentials")
  end

  def create(conn, %{"email" => email, "password" => password}) do
    case Accounts.get_user_by_email_and_password(email, password) do
      %User{} = user ->
        {:ok, jwt, _full_claims} = Guardian.encode_and_sign(user, %{})

        conn
        |> render("user_created.json", user: user, jwt: jwt)

      _ ->
        conn
        |> put_status(401)
        |> render("error.json", message: "Wrong credentials")
    end
  end
end
