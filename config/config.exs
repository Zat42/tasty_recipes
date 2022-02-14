# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :tasty_recipes,
  ecto_repos: [TastyRecipes.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :tasty_recipes, TastyRecipesWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "eLCZXLSdbJv6vHUEQjUTILjzQfOK5KkFDZvDRD8JqEZRFMq2o6j1YXxeTieH6BOz",
  render_errors: [view: TastyRecipesWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: TastyRecipes.PubSub,
  live_view: [signing_salt: "VfEabik9"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :tasty_recipes, TastyRecipes.Guardian,
  secret_key: "QEijcHVZw9X8lgP/9TJROU+MVyvUMLv/mUY2+Kx7XwXfXeVACQsX4vTfaiLapTLv",
  issuer: "tasty_recipes",
  ttl: {7, :days}

config :tasty_recipes, TastyRecipesWeb.ApiAuthPipeline,
  error_handler: TastyRecipesWeb.ApiAuthErrorHandler,
  module: TastyRecipes.Guardian

config :nostrum,
  token: "ODg3NzQxOTIxMTA2MjAyNjc2.YUIkFw.Ao0Im5olpyOM0asBbkuiuGCcVhI" # The token of your bot as a string
