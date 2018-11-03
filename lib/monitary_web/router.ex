defmodule MonitaryWeb.Router do
  use MonitaryWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_user_token
  end

  # pipeline :api do
  #   plug :accepts, ["json"]
  # end

  pipeline :auth do
    plug Monitary.Auth.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated#, claims: %{"typ" => "access"}
  end

  scope "/", MonitaryWeb do
    pipe_through [:browser, :auth]

    get "/", SessionController, :index

    # Session - login/logout
    post "/", SessionController, :login
    post "/logout", SessionController, :logout

  end

  # Authenticated routes
  scope "/", MonitaryWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    resources "/muns", MunController do
      resources "/transactions", TransactionController do
        resources "/items", ItemController
      end
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", MonitaryWeb do
  #   pipe_through :api
  # end

  defp put_user_token(conn, _) do
    if current_user = conn.assigns[:current_user] do
      token = Phoenix.Token.sign(conn, "user socket", current_user.id)
      assign(conn, :user_token, token)
    else
      conn
    end
  end

end
