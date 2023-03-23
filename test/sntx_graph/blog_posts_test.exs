defmodule SntxGraph.BlogPostsTest do
  use SntxWeb.ConnCase

  alias Sntx.Blog.Post
  alias Sntx.Guardian
  alias Sntx.User.{Account, Activations, Auth}

  @list_blog_post_query """
    query {
      listPosts {
        title
      }
    }
  """

  @get_blog_post_query """
   query getBlogPost($id: UUID4!) {
      getBlogPost(id: $id) {
        title
      }
    }
  """

  @create_blog_post_mutation """
  mutation {
    blogPostCreate(input: {title: "my elixir code", body: "IO.puts(:hello)"}) {
      result {
        title
        body
      }
    }
  }
  """

  @edit_blog_post_mutation """
  mutation blogPostUpdate($id: UUID4!) {
    blogPostUpdate(id: $id, input: {title: "my elixir code edited", body: "IO.puts(:hello_world)"}) {
      result {
        title
        body
      }
    }
  }
  """

  @delete_blog_post_mutation """
  mutation blogPostUpdate($id: UUID4!) {
    blogPostDelete(id: $id) {
      result
    }
  }
  """

  @user_email "test@test.com"
  @user_password "test.p4ssword"

  @input %{"body" => "IO.puts(:hello)", "title" => "my elixir code"}

  describe "queries" do
    setup do
      input = %{email: "query@test.com", password: @user_password}
      {:ok, user} = Account.create(input)

      [%{id: post_id}, _, _] =
        for title <- ["title1", "title2", "title3"] do
          {:ok, post} = Post.create(user.id, %{"body" => "IO.puts(:hello)", "title" => title})

          post
        end

      %{post_id: post_id}
    end

    test "get post", %{conn: conn, post_id: post_id} do
      conn =
        post(conn, "/graphql", %{
          "query" => @get_blog_post_query,
          "variables" => %{id: post_id}
        })

      assert json_response(conn, 200) == %{
               "data" => %{"getBlogPost" => %{"title" => "title1"}}
             }
    end

    test "list all posts", %{conn: conn} do
      conn =
        post(conn, "/graphql", %{
          "query" => @list_blog_post_query
        })

      assert json_response(conn, 200) == %{
               "data" => %{"listPosts" => [%{"title" => "title1"}, %{"title" => "title2"}, %{"title" => "title3"}]}
             }
    end
  end

  describe "mutations" do
    setup do
      input = %{email: @user_email, password: @user_password}
      {:ok, user} = Account.create(input)
      {:ok, _} = Activations.generate_token(user)

      {:ok, user} = Auth.login(input)
      {:ok, token, _} = Guardian.encode_and_sign(user)

      %{token: token, user_id: user.id}
    end

    test "create blog post", %{conn: conn, token: token} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> post("/graphql", %{
          "query" => @create_blog_post_mutation
        })

      assert json_response(conn, 200) == %{
               "data" => %{"blogPostCreate" => %{"result" => @input}}
             }
    end

    test "update blog post", %{conn: conn, token: token, user_id: user_id} do
      {:ok, post} = Post.create(user_id, @input)

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> post("/graphql", %{
          "query" => @edit_blog_post_mutation,
          "variables" => %{id: post.id}
        })

      assert json_response(conn, 200) == %{
               "data" => %{
                 "blogPostUpdate" => %{
                   "result" => %{"body" => "IO.puts(:hello_world)", "title" => "my elixir code edited"}
                 }
               }
             }
    end

    test "delete blog post", %{conn: conn, token: token, user_id: user_id} do
      {:ok, post} = Post.create(user_id, @input)

      conn =
        conn
        |> put_req_header("authorization", "Bearer #{token}")
        |> post("/graphql", %{
          "query" => @delete_blog_post_mutation,
          "variables" => %{id: post.id}
        })

      assert json_response(conn, 200) == %{
               "data" => %{"blogPostDelete" => %{"result" => true}}
             }
    end
  end
end
