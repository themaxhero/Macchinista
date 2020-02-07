# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :macchinista,
  ecto_repos: [Macchinista.Repo],
  token_secret: "TOPSECRETKEY"

# Configures the endpoint
config :macchinista, MacchinistaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "xcYrBXcC5ZJs+cmTpZAv141KYPAziKlGqaGr4ICioIpPCJC8Lkl6zvwIxLc7NxYj",
  render_errors: [view: MacchinistaWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Macchinista.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id],
  level: :info

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
