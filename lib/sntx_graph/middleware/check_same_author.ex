defmodule SntxGraph.Middleware.CheckSameAuthor do
  @moduledoc """
  Check if the blog author is the same as the logged user
  """

  @behaviour Absinthe.Middleware
  import SntxWeb.Gettext

  alias Sntx.Blog.Post
  alias Sntx.Repo

  def call(%{context: ctx, arguments: arguments} = res, _config) do
    post_id = arguments[:id]

    case Repo.get_by(Post, id: post_id, author_id: ctx.user.id) do
      nil ->
        Absinthe.Resolution.put_result(
          res,
          {:error, dgettext("global", "You must be the author of the blog post to perform this action")}
        )

      post ->
        Map.put(res, :blog_post_loaded, post)
    end
  end
end
