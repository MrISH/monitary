defmodule MonitaryWeb.LandingController do
  use MonitaryWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

end
