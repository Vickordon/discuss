defmodule Discuss.Repo.Migrations.AddPasswordHash do
  use Ecto.Migration
  def change do
    alter table(:topics) do
      add :password_hash, :string
    end
  end
end
