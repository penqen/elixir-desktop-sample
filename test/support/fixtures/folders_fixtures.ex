defmodule NoteApp.FoldersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `NoteApp.Folders` context.
  """

  @doc """
  Generate a note.
  """
  def note_fixture(attrs \\ %{}) do
    {:ok, note} =
      attrs
      |> Enum.into(%{
        context: "some context"
      })
      |> NoteApp.Folders.create_note()

    note
  end
end
