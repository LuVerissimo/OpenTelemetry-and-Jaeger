defmodule AppWeb.UserLive.FormComponent do
  use AppWeb, :live_component
  alias App.Accounts

  @impl true
  def update(%{user: user} = assigns, socket) do
    changeset = Accounts.change_user(user)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      socket.assigns.user
      |> Accounts.change_user(user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    save_user(socket, socket.assigns.action, user_params)
  end

  defp save_user(socket, :edit, user_params) do
    case Accounts.update_user(socket.assigns.user, user_params) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, "User updated successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_user(socket, :new, user_params) do
    case Accounts.create_user(user_params) do
      {:ok, _user} ->
        {:noreply,
         socket
         |> put_flash(:info, "User created successfully")
         |> push_navigate(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  # Helper functions for form_component.html.heex

  def label(changeset, field, opts \\ []) do
    form = to_form(changeset)
    Phoenix.HTML.Form.label(form, field, opts)
  end

  @spec text_input(any(), any(), any()) :: any()
  def text_input(changeset, field, opts \\ []) do
    form = to_form(changeset)
    Phoenix.HTML.Form.text_input(form, field, opts)
  end

  def error_tag(changeset, field) do
    form = to_form(changeset)
    Phoenix.HTML.Form.error_tag(form, field)
  end

  def submit(text, opts \\ []) do
    AppWeb.LiveHelpers.submit(text, opts)
  end
end
