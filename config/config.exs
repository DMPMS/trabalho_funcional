# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :twitter_clone,
  ecto_repos: [TwitterClone.Repo]

# Configures the endpoint
config :twitter_clone, TwitterCloneWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "UIGandoN2ESfVD5TrEi330HPJpFjqf2ID+R+6hacPC2TQkvqT2sWXSrsnyW6xPWI",
  render_errors: [view: TwitterCloneWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: TwitterClone.PubSub,
  live_view: [signing_salt: "rIVUCglA"]

# Configures Guardian
config :twitter_clone, TwitterClone.Guardian,
  issuer: "twitter_clone",
  secret_key:
    System.get_env("GUARDIAN_SECRET_KEY") ||
      "UIGandoN2ESfVD5TrEi330HPJpFjqf2ID+R+6hacPC2TQkvqT2sWXSrsnyW6x",
  token_ttl: %{
    "access" => {1, :hours}
  }

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
