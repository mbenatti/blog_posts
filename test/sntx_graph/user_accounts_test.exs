defmodule SntxGraph.UserAccountsTest do
  use SntxWeb.ConnCase

  @user_query """
  mutation {
    userCreate(input: {email: "test@test.com", password: "Test@test"}) {
      result {
        email
      }
    }
  }
  """

  test "query: user", %{conn: conn} do
    conn =
      post(conn, "/graphql", %{
        "query" => @user_query,
        "variables" => %{id: 1}
      })

    assert json_response(conn, 200) == %{
             "data" => %{"userCreate" => %{"result" => %{"email" => "test@test.com"}}}
           }
  end
end
