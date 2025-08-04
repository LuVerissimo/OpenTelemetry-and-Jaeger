defmodule App.Application do
  use Application

  @impl true
  def start(_type, _args) do
    :opentelemetry_cowboy.setup()

    OpenTelemetryPhoenix.setup(adapter: :cowboy2)
    OpenTelemetryEcto.setup([:app, :repo])

    children = [
      App.Repo,
      AppWeb.Telemetry,
      {Phoenix.PubSub, name: App.PubSub},
      AppWeb.Endpoint,
    ]
  end

  @impl true
  def config_change(changed, _new, removed) do
    AppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
