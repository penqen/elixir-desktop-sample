defmodule NoteAppWeb.NoteLive.Index do
  use NoteAppWeb, :live_view

  alias NoteApp.Folders
  alias NoteAppWeb.NoteLive.FormComponent

  @impl true
  def mount(params, _session, socket) do
    {
      :ok,
      socket
      |> assign_stream()
      |> assign_selected_note(params)
    }
  end

  defp assign_stream(socket) do
    stream(socket, :notes, Folders.list_notes())
  end

  defp assign_selected_note(socket, %{"id" => id}) do
    assign(socket, :note, Folders.get_note(id))
  end

  defp assign_selected_note(socket, _params) do
    assign(socket, :note, nil)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.sidebar>
      <:title_action>
        <.icon_button
          class="border-slate-400 text-slate-400 hover:bg-slate-700"
          id="create"
          phx-click="new"
        >
          <Lucide.plus
            stroke_width="1.5"
          />
        </.icon_button>
      </:title_action>
      <div class="h-full overflow-y-scroll scrollbar-hidden">
        <div class="flex flex-col">
          <a
            :for={{id, note} <- @streams.notes}
            id={id}
            href="#"
            phx-click="select"
            phx-value-id={note.id}
            class={[
              "text-md px-6 py-4 hover:bg-slate-800 transition",
              "whitespace-nowrap text-ellipsis overflow-hidden",
              "hover:border-slate-400 border-l-4",
              (@note == nil || @note.id != note.id) && "border-slate-900",
              @note && @note.id == note.id && "border-violet-400"
            ]}
          >
            <%= String.slice(note.context, 0..25) %>
          </a>
        </div>
      </div>
    </.sidebar>
    <main class="absolute left-[260px] top-0 bottom-0 right-0 overflow-hidden">
      <.live_component
        :if={@note != nil}
        module={FormComponent}
        id={@note.id}
        action={:edit}
        note={@note}
      />
    </main>
    """
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
  end

  @impl true
  def handle_info({FormComponent, {:deleted, _note}}, socket) do
    {:noreply, redirect(socket, to: ~p"/")}
  end

  @impl true
  def handle_info({FormComponent, {:saved, note}}, socket) do
    {:noreply, redirect(socket, to: ~p"/?id=#{note.id}")}
  end

  @impl true
  def handle_event("new", _params, socket) do
    case Folders.create_note(%{"context" => "新しいノート"}) do
      {:ok, note} ->
        {:noreply, redirect(socket, to: ~p"/?id=#{note.id}")}
      {:error, _} ->
        {
          :noreply,
          socket
          |> put_flash(:error, "Failed note created")
        }
    end
  end

  @impl true
  def handle_event("select", %{"id" => id}, socket) do
    {:noreply, redirect(socket, to: ~p"/?id=#{id}")}
  end
end
