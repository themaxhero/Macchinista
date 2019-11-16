defmodule Macchinista.Repo do
  use Ecto.Repo,
    otp_app: :macchinista,
    adapter: Ecto.Adapters.Postgres
end
