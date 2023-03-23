defmodule SntxGraph.BlogTypes do
  use Absinthe.Schema.Notation

  import AbsintheErrorPayload.Payload
  alias Sntx.Blog.Post

  payload_object(:blog_post_payload, :blog_post)

  object :blog_post do
    field :title, :string
    field :body, :string
  end

  input_object :blog_post_input do
    field :title, :string
    field :body, :string
  end
end
