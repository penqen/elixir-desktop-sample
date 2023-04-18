defmodule NoteApp.Repo do
  use Ecto.Repo,
    otp_app: :note_app,
    adapter: Ecto.Adapters.SQLite3
end
