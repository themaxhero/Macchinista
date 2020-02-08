defmodule Macchinista.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Macchinista.Repo
  alias Macchinista.Accounts.{User, Session}
  alias Session.Query, as: SessionQuery

  @token_secret Application.get_env(:macchinista, :token_secret)

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
  def get_user(id), do: Repo.get(User, id)
  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by_email(email), do: Repo.get_by(User, email: email)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    Repo.transaction(fn ->
      result =
        attrs
        |> User.create_changeset()
        |> Repo.insert()

      case result do
        {:ok, %User{} = user} ->
          # create_log(user, :user, :insert, :success, user)
          user

        {:error, _} ->
          Repo.rollback(:internal)
      end
    end)
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
    |> User.update_changeset(attrs)
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

  def login(%{email: email, password: password}) do
    with user <- get_user_by_email(email),
         true <- Bcrypt.verify_pass(password, user.password_hash) do
      IO.puts(@token_secret)
      {:ok, Phoenix.Token.sign(@token_secret, "user", user.id)}
    else
      {:error, _} = response -> response
      false -> {:error, :invalid_credentials}
      _ -> {:error, :unknown_error}
    end
  end

  @spec validate_user(User.t() | nil) ::
          {:ok, User.t()}
          | {:error, :invalid_authorization_token}
  defp validate_user(%User{} = user), do: {:ok, user}
  defp validate_user(_), do: {:error, :invalid_authorization_token}

  @spec authorize_user(Session.token()) ::
          {:ok, User.t()}
          | {:error, :invalid_authorization_token}
  def authorize_user(token) do
    token
    |> SessionQuery.by_token()
    |> Repo.one()
    |> Session.get_user_id()
    |> get_user()
    |> validate_user()
  end
end
