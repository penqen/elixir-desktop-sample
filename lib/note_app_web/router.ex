defmodule NoteAppWeb.Router do
  use NoteAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {NoteAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NoteAppWeb do
    pipe_through :browser

    live "/", NoteLive.Index, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", NoteAppWeb do
  #   pipe_through :api
  # end
end
