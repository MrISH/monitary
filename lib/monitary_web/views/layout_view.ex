defmodule MonitaryWeb.LayoutView do
  use MonitaryWeb, :view

  def current_user(conn) do
    Monitary.Auth.current_user(conn)
  end

  def user_token(conn) do
    Monitary.Auth.user_token(conn)
  end
  
end
