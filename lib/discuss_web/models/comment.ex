defmodule DiscussWeb.Models.Comment do
  use DiscussWeb, :model

  @derive {Jason.Encoder, only: [:content, :user]}

  schema "comments" do
    field :content, :string
    belongs_to :user, DiscussWeb.Models.User
    belongs_to :topic, DiscussWeb.Models.Topic

    timestamps()
  end

  def changeset(struct, params \\ %{}) do

    struct
    |> cast(params, [:content])
    |> validate_required([:content])
  end

end
