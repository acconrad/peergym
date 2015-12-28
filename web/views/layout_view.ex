defmodule Peergym.LayoutView do
  use Peergym.Web, :view

  def action_name(conn) do
    Phoenix.Controller.action_name conn
  end

  def body_class(conn) do
    "#{controller_name conn} #{action_name conn}"
  end

  def controller_name(conn) do
    Phoenix.Naming.resource_name Phoenix.Controller.controller_module(conn), "Controller"
  end

  def form_location_prefill(city, state) do
    if city && state do
      "#{city}, #{state}"
    else
      ""
    end
  end
end
