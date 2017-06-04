defmodule Inception.ApiTest do
  use ExUnit.Case
  alias Inception.Api.Definition, as: Def
  alias Def.Endpoint, as: Endpoint
  alias Def.Endpoint.QueryParam, as: QueryParam

  defmodule MyApi do
    use Inception.Api

    api_definition do
      path "users" do
        get do
          query_param "sort_by", :string
        end
        # post "" do
        #   consumes [:json]
        #   produces [:json]
        #   body do
        #     schema User
        #   end
        #   response 200
        #   response 400
        # end
      end
      path "accounts" do
        get do
        #  query_param "sort_by", :string
        end
      end
    end

    def get_schema do
      @api_definition
    end
  end

  def get_schema do
    MyApi.get_schema
  end

  test "it defines a schema" do
    %Def{} = get_schema
  end

  test "it defines endpoints inside the schema" do
    %Def{
      endpoints: [
        %Endpoint{path: "/users", verb: :get},
        %Endpoint{path: "/accounts", verb: :get}
      ]
    } = get_schema
  end

  test "it defines query params" do
    [users_endpoint | _] = get_schema.endpoints
    assert users_endpoint.query_params == [
      %QueryParam{key: "sort_by", type: :string}
    ]
  end
end
