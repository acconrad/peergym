# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :peergym, Peergym.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "8vNwY7LhcY3hqsBLAP/m44potAU1CrR9f1dbqK1B7VgrMc3w6yFECjUbb2xBjHfi",
  debug_errors: false,
  pubsub: [name: Peergym.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure Addict authentication system
config :addict, not_logged_in_url: "/error",  # the URL where users will be redirected to
  db: Peergym.Repo,
  user: Peergym.User,
  register_from_email: "Registration <welcome@peergym.com>", # email registered users will receive from address
  register_subject: "Welcome to PeerGym!", # email registered users will receive subject
  password_recover_from_email: "Password Recovery <no-reply@peergym.com>",
  password_recover_subject: "You requested a password recovery link",
  email_templates: PeerGym.EmailTemplates # email templates for sending e-mails, more on this further down
