defmodule Sntx.Blog.Post do
  use Sntx.Schema
  use Waffle.Ecto.Schema

  import Ecto.Changeset
  import SntxWeb.Gettext

  alias __MODULE__, as: Post
  alias Sntx.Models.User.Account
  alias Sntx.Repo

  schema "blog_posts" do
    field :title, :string
    field :body, :string
    belongs_to :author, Account
  end

  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
  end

  def create(author_id, attrs) do
    %Post{author_id: author_id}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def update(post, attrs) do
    post
    |> changeset(attrs)
    |> Repo.update()
  end

  def delete(post) do
    Repo.delete(post)
  end
end
