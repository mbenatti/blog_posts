defmodule SntxGraph.BlogMutations do
  @moduledoc """
  Graphql Mutations for blog context
  """

  use Absinthe.Schema.Notation

  alias SntxGraph.Middleware.{Authorize, CheckSameAuthor}
  alias SntxGraph.BlogResolver

  object :blog_mutations do
    field :blog_post_create, :blog_post_payload do
      arg :input, non_null(:blog_post_input)

      middleware(Authorize)

      resolve(&BlogResolver.create_post/2)
    end

    field :blog_post_update, type: :blog_post_payload do
      arg :id, non_null(:uuid4)
      arg :input, non_null(:blog_post_input)

      middleware(CheckSameAuthor)

      resolve(&BlogResolver.update_post/2)
    end

    field :blog_post_delete, type: :boolean_payload do
      arg :id, non_null(:uuid4)

      middleware(CheckSameAuthor)

      resolve(&BlogResolver.delete_post/2)
    end
  end
end
