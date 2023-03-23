defmodule Sntx.Blog.Post do
  @moduledoc """
  Schema representing a Blog Post
  """

  use Sntx.Schema
  use Waffle.Ecto.Schema

  import Ecto.Changeset
  import SntxWeb.Gettext

  alias __MODULE__, as: Post
  alias Sntx.Models.User.Account
  alias Sntx.Repo

  @type t :: %__MODULE__{
          title: String.t(),
          body: String.t(),
          author_id: String.t()
        }

  schema "blog_posts" do
    field :title, :string
    field :body, :string
    belongs_to :author, Account
  end

  @spec changeset(Post.t(), map()) :: Changeset.t()
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
  end

  @spec create(String.t(), map()) :: {:ok, Post.t()} | {:error, Ecto.Changeset.t()}
  def create(author_id, attrs) do
    %Post{author_id: author_id}
    |> changeset(attrs)
    |> Repo.insert()
  end

  @spec update(Post.t(), map()) :: {:ok, Post.t()} | {:error, Ecto.Changeset.t()}
  def update(post, attrs) do
    post
    |> changeset(attrs)
    |> Repo.update()
  end

  @spec delete(Post.t()) :: {:ok, Post.t()} | {:error, Ecto.Changeset.t()}
  def delete(post) do
    Repo.delete(post)
  end
end
