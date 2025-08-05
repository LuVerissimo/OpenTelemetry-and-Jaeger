defmodule AppWeb.LiveHelpers do
  import Phoenix.Component

  alias Phoenix.LiveView.JS

  def modal(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)

    ~H"""
    <div id="modal" class="phx-modal fade-in" phx-remove={hide_modal()}>
      <div
        id="modal-content"
        class="phx-modal-content fade-in-scale"
        phx-click-away={JS.dispatch("click", to: "#modal-close")}
        phx-key="Escape"
        phx-window-keydown={JS.dispatch("click", to: "#modal-close")}
      >
        <%= if @return_to do %>
          <.link
            navigate={@return_to}
            id="modal-close"
            class="phx-modal-close"
            phx-click={hide_modal()}
          >
            X
          </.link>
        <% else %>
          <.link href="#" id="modal-close" class="phx-modal-close" phx-click={hide_modal()}>
            X
          </.link>
        <% end %>

        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.remove_class(to: "#modal-content", transition: "fade-out-scale")
  end
end
