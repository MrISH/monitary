# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :monitary,
  ecto_repos: [Monitary.Repo]

# Configures the endpoint
config :monitary, MonitaryWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "c71LocqxQ1OmE1XPtjTrHkWRhbnmctF//Zea1dPZOEoLp+Gt4yQ+AYOHZ+BDSxJN",
  render_errors: [view: MonitaryWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Monitary.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Configures Guardian
config :monitary, Monitary.Auth.Guardian,
  issuer: "monitary",
  secret_key: "7X90CWStO0ovdErFnqPg7JX7lyhHPhAh97imfCtM8TUo9ExELHfpfrFuOFTK9z/T"


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
