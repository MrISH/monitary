defmodule Monitary.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  import Plug.Conn

  alias Monitary.Repo
  alias Monitary.Auth.User
  alias Comeonin.Bcrypt

  @doc """
  Authenticates User's password
  """
  def authenticate_user(username, plain_text_password) do
    query = from u in User, where: u.username == ^username
    Repo.one(query)
    |> check_password(plain_text_password)
  end

  defp check_password(nil, _), do: {:error, "Incorrect username or password"}
  defp check_password(user, plain_text_password) do
    case Bcrypt.checkpw(plain_text_password, user.password) do
      true -> {:ok, user}
      false -> {:error, "Incorrect username or password"}
    end
    # {:ok, user}
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Returns an `%Auth.User{}` for validation, authorisation, and access.

  ## Examples

      iex> current_user(conn)
      %Auth.User{}

  """
  def current_user(conn) do
    # user_id = Plug.Conn.get_session(conn, :current_user_id)
    # user_id = Guardian.Plug.current_resource(conn).id
    # if user_id, do: Repo.get(User, user_id)
    Guardian.Plug.current_resource(conn)
  end

  @doc """
  Returns a true/false if a current_user exists

  ## Examples

      iex> user_signed_in?(conn)
      true # / false

  """
  def user_signed_in?(conn) do
    !!current_user(conn)
  end

  @doc """
  Returns a token for authorisation of channel messages

  ## Examples

      iex> user_token(conn)
      "SFMyNTY.g3QAAAACZAAEZGF0YXQAAAAIZAAIX19tZXRhX190AAAABGQACl9fc3RydWN0X19kABtFbGl4aXIuRWN0by5TY2hlbWEuTWV0YWRhdGFkAAdjb250ZXh0ZAADbmlsZAAGc291cmNlaAJkAANuaWxtAAAABXVzZXJzZAAFc3RhdGVkAAZsb2FkZWRkAApfX3N0cnVjdF9fZAAZRWxpeGlyLk1vbml0YXJ5LkF1dGguVXNlcmQAAmlkYQJkAAtpbnNlcnRlZF9hdHQAAAAJZAAKX19zdHJ1Y3RfX2QAFEVsaXhpci5OYWl2ZURhdGVUaW1lZAAIY2FsZW5kYXJkABNFbGl4aXIuQ2FsZW5kYXIuSVNPZAADZGF5YQRkAARob3VyYQ9kAAttaWNyb3NlY29uZGgCYgAOSkBhBmQABm1pbnV0ZWEDZAAFbW9udGhhCGQABnNlY29uZGEyZAAEeWVhcmIAAAfiZAAEbXVuc3QAAAAEZAAPX19jYXJkaW5hbGl0eV9fZAAEbWFueWQACV9fZmllbGRfX2QABG11bnNkAAlfX293bmVyX19kABlFbGl4aXIuTW9uaXRhcnkuQXV0aC5Vc2VyZAAKX19zdHJ1Y3RfX2QAIUVsaXhpci5FY3RvLkFzc29jaWF0aW9uLk5vdExvYWRlZGQACHBhc3N3b3JkbQAAADwkMmIkMTIkZkVyNWE1SFZwTHlUbUEzTmFFMTNlT0VDRXhOTlRkUDZpbi9Ob0IxdUF2b3d3STRJSGlkSS5kAAp1cGRhdGVkX2F0dAAAAAlkAApfX3N0cnVjdF9fZAAURWxpeGlyLk5haXZlRGF0ZVRpbWVkAAhjYWxlbmRhcmQAE0VsaXhpci5DYWxlbmRhci5JU09kAANkYXlhBGQABGhvdXJhD2QAC21pY3Jvc2Vjb25kaAJiAA5KTWEGZAAGbWludXRlYQNkAAVtb250aGEIZAAGc2Vjb25kYTJkAAR5ZWFyYgAAB-JkAAh1c2VybmFtZW0AAAADaXNoZAAGc2lnbmVkbgYA4XSNJ2UB.8H3gk3rHRWzNPraNr6WV56oOz_knM2I4TgSRSyHLSSQ"

  """
  def user_token(conn) do
    Phoenix.Token.sign(conn, "user socket", current_user(conn))
  end

end
