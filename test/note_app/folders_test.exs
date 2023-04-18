defmodule NoteApp.FoldersTest do
  use NoteApp.DataCase

  alias NoteApp.Folders

  describe "notes" do
    alias NoteApp.Folders.Note

    import NoteApp.FoldersFixtures

    @invalid_attrs %{context: nil}

    test "list_notes/0 returns all notes" do
      note = note_fixture()
      assert Folders.list_notes() == [note]
    end

    test "get_note!/1 returns the note with given id" do
      note = note_fixture()
      assert Folders.get_note!(note.id) == note
    end

    test "create_note/1 with valid data creates a note" do
      valid_attrs = %{context: "some context"}

      assert {:ok, %Note{} = note} = Folders.create_note(valid_attrs)
      assert note.context == "some context"
    end

    test "create_note/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Folders.create_note(@invalid_attrs)
    end

    test "update_note/2 with valid data updates the note" do
      note = note_fixture()
      update_attrs = %{context: "some updated context"}

      assert {:ok, %Note{} = note} = Folders.update_note(note, update_attrs)
      assert note.context == "some updated context"
    end

    test "update_note/2 with invalid data returns error changeset" do
      note = note_fixture()
      assert {:error, %Ecto.Changeset{}} = Folders.update_note(note, @invalid_attrs)
      assert note == Folders.get_note!(note.id)
    end

    test "delete_note/1 deletes the note" do
      note = note_fixture()
      assert {:ok, %Note{}} = Folders.delete_note(note)
      assert_raise Ecto.NoResultsError, fn -> Folders.get_note!(note.id) end
    end

    test "change_note/1 returns a note changeset" do
      note = note_fixture()
      assert %Ecto.Changeset{} = Folders.change_note(note)
    end
  end
end
