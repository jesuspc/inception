defmodule Inception.PlugTest do
  use ExUnit.Case
  use Plug.Test

  defmodule Http.Router do
    use Plug.Router

    plug :match
    plug :dispatch

    # plug Inception.Plug.build(MyApi)

    match _ do
      send_resp conn, 404, ""
    end
  end

  def do_request(c) do
    c |> Http.Router.call(Http.Router.init([]))
  end

  test "it fallbacks when route not matched" do
    resp = conn(:get, "/fake") |> do_request
    assert resp.status == 404
  end
end
