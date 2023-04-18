defmodule NoteApp.Repo.Migrations.CreateNotes do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add :context, :string

      timestamps()
    end
  end
end
