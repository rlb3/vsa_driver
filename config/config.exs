# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :vsa_driver,
  ecto_repos: [VsaDriver.Repo]

# Configures the endpoint
config :vsa_driver, VsaDriverWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ya028owJe5yzRBwrQGXNk6OW9Wtu7gWRxICQ/vZJQgjtxhDeHHTxMBEbBQ8Iq11b",
  render_errors: [view: VsaDriverWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: VsaDriver.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :phoenix, :format_encoders,
  "json-api": Poison

config :mime, :types, %{
  "application/vnd.api+json" => ["json-api"]
}

config :ja_serializer,
  pluralize_types: true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
