defmodule Peergym do
  @moduledoc """
  The main module for starting and configuring the Peergym web application.
  """

  use Application
  alias Peergym.Endpoint

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Start the endpoint when the application starts
      supervisor(Peergym.Endpoint, []),
      # Start the Ecto repository
      worker(Peergym.Repo, []),
      # Here you could define other workers and supervisors as children
      # worker(Peergym.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Peergym.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Endpoint.config_change(changed, removed)
    :ok
  end
end
