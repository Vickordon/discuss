defmodule DiscussWeb.Models.User do
  use DiscussWeb, :model

  @derive {Jason.Encoder, only: [:email, :token]}

  schema "users" do
    field :email, :string
    field :provider, :string
    field :token, :string

    has_many :topics, DiscussWeb.Models.Topic
    has_many :comments, DiscussWeb.Models.Comment
    timestamps()
  end

  def changeset(struct, params \\ %{})do
    struct
    |>cast(params, [:email, :provider, :token])
    |>validate_required([:email,:provider, :token])
  end

end
