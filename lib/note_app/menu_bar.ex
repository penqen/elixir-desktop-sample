defmodule NoteApp.MenuBar do
  @moduledoc """
    Menubar that is shown as part of the main Window on Windows/Linux. In
    MacOS this Menubar appears at the very top of the screen.
  """
  import NoteAppWeb.Gettext
  use Desktop.Menu
  alias Desktop.Window

  def render(assigns) do
    ~H"""
    <menubar>
    <menu label={gettext "File"}>
        <item onclick="quit"><%= gettext "Quit" %></item>
    </menu>
    <menu label={gettext "Extra"}>
        <item onclick="observer"><%= gettext "Show Observer" %></item>
        <item onclick="browser"><%= gettext "Open Browser" %></item>
    </menu>
    </menubar>
    """
  end

  def handle_event("observer", menu) do
    :observer.start()
    {:noreply, menu}
  end

  def handle_event("quit", menu) do
    Window.quit()
    {:noreply, menu}
  end

  def handle_event("browser", menu) do
    Window.prepare_url(NoteAppWeb.Endpoint.url())
    |> :wx_misc.launchDefaultBrowser()

    {:noreply, menu}
  end

  def mount(menu) do
    {:ok, assign(menu, notes: [])}
  end

  def handle_info(:changed, menu) do
    {:noreply, assign(menu, notes: [])}
  end
end
