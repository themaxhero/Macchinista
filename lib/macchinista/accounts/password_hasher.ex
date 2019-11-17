defmodule Macchinista.Accounts.PasswordHasher do
  def hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    update_changeset = &Ecto.Changeset.put_change(changeset, :password_hash, &1)

    password
    |> Bcrypt.Base.hash_password(Bcrypt.gen_salt(4, true))
    |> update_changeset.()
  end

  def hash_password(changeset), do: changeset
end
