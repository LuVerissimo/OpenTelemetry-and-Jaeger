defmodule App.UserLive.Show do
  use AppWeb, :live_view

  alias App.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :user, nil)}
  end

  @impl true
  def handle_params(%{"id" => id}, _url, socket) do
    user = Accounts.get_user!(id)

    {:noreply,
     assign(socket, :user)
     |> assign(:page_title, page_title(:show))
     |> assign(:user, user)}
  end

  defp page_title(:show), do: "Show User"
  defp page_title(:edit), do: "Edit User"
end
