defmodule TastyRecipesWeb.Api.SessionView do
  use TastyRecipesWeb, :view

  def render("user_created.json", %{user: user, jwt: jwt}) do
    %{
      data: %{
        token: jwt,
        email: user.email
      },
      status: :ok,
      message: "Successful log in"
    }
  end

  def render("error.json", %{message: message}) do
    %{
      data: %{},
      status: :not_found,
      message: message
    }
  end
end
