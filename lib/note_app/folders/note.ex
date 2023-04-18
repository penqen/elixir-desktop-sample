defmodule NoteApp.Folders.Note do
  use Ecto.Schema
  import Ecto.Changeset

  schema "notes" do
    field :context, :string

    timestamps()
  end

  @doc false
  def changeset(note, attrs) do
    note
    |> cast(attrs, [:context])
    |> validate_required([:context])
  end
end
