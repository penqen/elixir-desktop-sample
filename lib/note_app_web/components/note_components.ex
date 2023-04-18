defmodule NoteAppWeb.NoteComponents do
  use Phoenix.Component

  attr :title, :string, default: "NoteApp"

  slot :title_action
  slot :inner_block

  import NoteAppWeb.CoreComponents, only: [translate_error: 1]

  def sidebar(assigns) do
    ~H"""
    <aside class={[
      "flex flex-col items-stretch",
      "absolute bg-[#0f172a] text-white top-0 left-0 bottom-0 w-[260px]"
    ]}>
      <div
        class={[
          "flex flex-row items-center justify-between",
          "h-[56px] px-6 p-3"
        ]}
      >
        <p class="-m-1.5 p-1.5 text-2xl">
          <%= @title %>
        </p>
        <div
          :if={@title_action != []}
          class=""
        >
          <%= render_slot(@title_action) %>
        </div>
      </div>
      <divider class="w-full border-b border-slate-600" />
      <%= render_slot(@inner_block) %>
    </aside>
    """
  end

  attr :type, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)
  attr :border, :boolean, default: false

  slot :inner_block, required: true

  @spec icon_button(map) :: Phoenix.LiveView.Rendered.t()
  def icon_button(assigns) do
    ~H"""
    <button
      type={@type}
      class={[
        "p-2",
        @border && "border boder-2",
        "rounded-md",
        "transition",
        @class
      ]}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  @doc"""
  Renders a header.
  """
  attr :class, :string, default: nil
  attr :inner_class, :string, default: nil

  slot :inner_block, required: true
  slot :title
  slot :left_actions
  slot :right_actions

  def header(assigns) do
    ~H"""
    <header
      class={[
        "flex items-center gap-6 px-6",
        @class
      ]}
    >
      <h1
        :if={@title != []}
        class="text-lg font-semibold leading-8 text-zinc-800"
      >
        <%= render_slot(@title) %>
      </h1>
      <div
        :if={@left_actions != []}
        class="flex-none"
      >
        <%= render_slot(@left_actions) %>
      </div>
      <div class={[
        "flex grow",
        @inner_class
      ]}>
        <%= render_slot(@inner_block) %>
      </div>
      <div
        :if={@right_actions != []}
        class="flex-none"
      >
        <%= render_slot(@right_actions) %>
      </div>
    </header>
    """
  end

  @doc"""
  Renders a footer.

  ## Examples

      <.footer>Footer</.footer>
  """
  attr :class, :string, default: nil
  slot :inner_block, required: true
  def footer(assigns) do
    ~H"""
    <footer
      class={[
        "flex items-center gap-6 px-6",
        @class
      ]}
    >
      <%= render_slot(@inner_block) %>
    </footer>
    """
  end

  @doc"""
  Renders a textarea.

  ## Examples

      <.textarea />
  """
  attr :id, :any, default: nil
  attr :name, :any
  attr :class, :string, default: nil
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"
  attr :value, :any
  attr :rest, :global

  attr :field, Phoenix.HTML.FormField

  def textarea(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> render_textarea()
  end

  defp render_textarea(assigns) do
    ~H"""
    <textarea
      id={@id}
      name={@name}
      class={[
        "w-full",
        @class
      ]}
      {@rest}
    ><%= Phoenix.HTML.Form.normalize_value("textarea", @value) %></textarea>
    """
  end

  @doc"""
  Renders a error.

  ## Examples

      <.error_msg field={@form[:context]} />
  """
  attr :field, Phoenix.HTML.FormField

  def error_msg(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(:errors, Enum.map(field.errors, &translate_error(&1)))
    |> render_error_msg()
  end

  defp render_error_msg(assigns) do
    ~H"""
    <p class="text-sm leading-6 text-rose-600">
      <%= for msg <- @errors do %>
        <%= msg %>
      <% end %>
    </p>
    """
  end
end
