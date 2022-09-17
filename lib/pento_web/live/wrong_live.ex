defmodule PentoWeb.WrongLive do
  @moduledoc false

  use Phoenix.LiveView, layout: {PentoWeb.LayoutView, "live.html"}

  alias Phoenix.LiveView.Socket

  @spec mount(any, any, Socket.t()) :: {:ok, Socket.t()}
  def mount(_params, session, socket) do
    socket
    |> assign(:score, 0)
    |> assign(:message, "Make a guess: ")
    |> assign(:actual, rand_num())
    |> assign(:session_id, session["live_socket_id"])
    |> then(&{:ok, &1})
  end

  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
    </h2>
    <h2>
      <%= for n <- 1..10 do %>
        <a href="#" phx-click="guess" phx-value-number= {n} ><%= n %></a>
      <% end %>
      <pre>
        <%= @current_user.email %>
        <%= @session_id %>
      </pre>
    </h2>
    """
  end

  @spec handle_event(binary(), map(), Socket.t()) :: {:noreply, Socket.t()}
  def handle_event("guess", %{"number" => guess}, %Socket{assigns: %{actual: actual}} = socket)
      when guess == actual do
    message = "Correct. Try to guess the next number"
    score = socket.assigns.score + 1
    {:noreply, assign(socket, message: message, score: score, actual: rand_num())}
  end

  def handle_event("guess", %{"number" => guess}, %Socket{} = socket) do
    message = "Your guess: #{guess}. Wrong. Guess Again."
    score = socket.assigns.score - 1
    {:noreply, assign(socket, message: message, score: score)}
  end

  defp rand_num do
    1..10 |> Enum.random() |> to_string()
  end
end
