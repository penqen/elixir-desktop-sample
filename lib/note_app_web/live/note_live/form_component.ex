defmodule NoteAppWeb.NoteLive.FormComponent do
  use NoteAppWeb, :live_component

  alias NoteApp.Folders

  @impl true
  def render(assigns) do
    ~H"""
    <div class="h-full">
      <.simple_form
        for={@form}
        id="note-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.header
          class="h-[56px] border-b-2 border-slate-300"
        >
          <:left_actions>
            <.icon_button
              :if={@note != nil}
              class="border-none text-red-400 hover:bg-red-100"
              phx-target={@myself}
              phx-click="delete"
              phx-value-id={@note.id}
            >
              <Lucide.trash
                stroke_width={1.5}
              />
            </.icon_button>
          </:left_actions>
          <:right_actions>
            <.icon_button
              :if={@note != nil}
              class="border-none text-teal-500 hover:bg-teal-100"
              type="submit"
              phx-value-id={@note.id}
            >
              <Lucide.save
                stroke_width={1.5}
              />
            </.icon_button>
          </:right_actions>
        </.header>
        <.textarea
          class="h-[calc(100vh-56px-56px)] note-input"
          field={@form[:context]}
        />
        <.footer
          class="h-[56px] border-t border-slate-400"
        >
          <.error_msg field={@form[:context]} />
        </.footer>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{note: note} = assigns, socket) do
    changeset = Folders.change_note(note)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    note = Folders.get_note!(id)
    {:ok, _} = Folders.delete_note(note)
    notify_parent({:deleted, note})
    {
      :noreply,
      socket
      |> put_flash(:info, "Note deleted successfully")
    }
  end

  @impl true
  def handle_event("validate", %{"note" => note_params}, socket) do
    changeset =
      socket.assigns.note
      |> Folders.change_note(note_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("save", %{"note" => note_params}, socket) do
    save_note(socket, socket.assigns.action, note_params)
  end

  defp save_note(socket, :edit, note_params) do
    case Folders.update_note(socket.assigns.note, note_params) do
      {:ok, note} ->
        notify_parent({:saved, note})
        {
          :noreply,
          socket
          |> put_flash(:info, "Note saved successfully")
        }
      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
