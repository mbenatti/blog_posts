defmodule SntxGraph.BlogResolver do
  @moduledoc """
  Graphql Resolver for blog context
  """

  import SntxWeb.Payload

  alias Sntx.Repo
  alias Sntx.Blog.Post

  @spec get_post(map(), map()) :: {:ok, Post.t()}
  def get_post(%{id: id}, _), do: {:ok, Repo.get(Post, id)}

  @spec get_posts(map(), map()) :: {:ok, [Post.t()]}
  def get_posts(_, _), do: {:ok, Repo.all(Post)}

  def create_post(%{input: input}, %{context: ctx}) do
    case Post.create(ctx.user.id, input) do
      {:ok, post} -> {:ok, post}
      error -> mutation_error_payload(error)
    end
  end

  def update_post(%{input: input}, %{blog_post_loaded: post}) do
    with {:ok, post} <- Post.update(post, input) do
      {:ok, post}
    else
      nil -> default_error(:not_found)
      error -> mutation_error_payload(error)
    end
  end

  def delete_post(%{id: _}, %{blog_post_loaded: post}) do
    with {:ok, _post} <- Post.delete(post) do
      {:ok, true}
    else
      nil -> default_error(:not_found)
      error -> mutation_error_payload(error)
    end
  end
end
