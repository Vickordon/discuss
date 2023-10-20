defmodule DiscussWeb.CommentChannel do
  use DiscussWeb, :channel
  import Ecto
  alias Discuss.Repo
  alias DiscussWeb.Models.{Topic,Comment}

  @impl true
  def join("comment:" <> topic_id, _payload, socket) do
    topic_id = String.to_integer(topic_id)
    topic = Topic
      |> Repo.get( topic_id)
      |> Repo.preload(comments: [:user])

# IO.inspect(topic.comments)
      {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)} # assign(socket, :topic, topic) - добавляємо властивість topic в socket щоб можна було її отримати в handle_in
  end

  @impl true
  def handle_in(_name, %{"content" => content}, socket) do
    IO.puts("handle_in is called")
    topic = socket.assigns.topic
    # IO.inspect(topic)
    user_id = socket.assigns.user_id
    IO.inspect(user_id)
    changeset = topic
      |> build_assoc(:comments, user_id: user_id)
      |> Comment.changeset(%{content: content})
    case Repo.insert(changeset) do
      {:ok, comment} ->
        broadcast!(socket, "comments:#{socket.assigns.topic.id}:new", %{comment: comment})
        {:reply, :ok, socket}
      {:error, _reasone} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (comment:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
