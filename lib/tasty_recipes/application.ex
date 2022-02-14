defmodule TastyRecipes.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      TastyRecipes.Repo,
      # Start the Telemetry supervisor
      TastyRecipesWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: TastyRecipes.PubSub},
      # Start the Endpoint (http/https)
      TastyRecipesWeb.Endpoint,
      # Start a worker by calling: TastyRecipes.Worker.start_link(arg)
      # {TastyRecipes.Worker, arg}
      TastyRecipes.BotConsumer
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TastyRecipes.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TastyRecipesWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
