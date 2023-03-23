defmodule SntxGraph.BlogQueries do
  @moduledoc """
  Graphql queries for blog context
  """

  use Absinthe.Schema.Notation

  alias SntxGraph.BlogResolver

  object :blog_queries do
    field :list_posts, list_of(:blog_post) do
      resolve(&BlogResolver.get_posts/2)
    end

    field :get_blog_post, :blog_post do
      arg :id, :uuid4
      resolve(&BlogResolver.get_post/2)
    end
  end
end
