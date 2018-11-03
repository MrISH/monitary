defmodule Monitary.Auth.Authoriser do

  def can_manage?(user, mun) do
    user && user.id == mun.user_id
  end

end
