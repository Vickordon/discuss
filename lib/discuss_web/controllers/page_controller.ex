defmodule DiscussWeb.PageController do
  use DiscussWeb, :controller

  def index(conn, _params) do
    IO.inspect conn
    render(conn, "index.html")
  end
end
