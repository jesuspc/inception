defmodule Inception.ApiTest do
  use ExUnit.Case
  alias Inception.Api.Definition, as: Def
  alias Def.Endpoint, as: Endpoint
  alias Def.Endpoint.QueryParam, as: QueryParam
  alias Def.Endpoint.Format, as: Format

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
        %Endpoint{path: "/users", verb: :post},
        %Endpoint{path: "/users", verb: :put},
        %Endpoint{path: "/users", verb: :delete},
        %Endpoint{path: "/users", verb: :head},
        %Endpoint{path: "/users", verb: :patch},
        %Endpoint{path: "/accounts", verb: :get}
      ]
    } = get_schema
  end

  test "it defines query params" do
    [users_endpoint | _] = get_schema.endpoints
    assert users_endpoint.query_params == [
      %QueryParam{key: "sort_by", type: :string, kind: :optional}
    ]
  end

  test "it defines input formats" do
    users_post_endpoint = get_schema.endpoints |> Enum.at(1)
    assert users_post_endpoint.input_formats == [
      %Format{label: :json}
    ]
  end

  test "it defines output formats" do
    users_post_endpoint = get_schema.endpoints |> Enum.at(1)
    assert users_post_endpoint.output_formats == [
      %Format{label: :csv}
    ]
  end
end
