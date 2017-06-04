defmodule Inception.Api do
  alias Inception.Api.Definition, as: Def
  alias Def.Endpoint, as: Endpoint
  alias Endpoint.QueryParam, as: QueryParam
  import Lens
  import Focus

  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
    end
  end

  defmacro api_definition(do: block) do
    quote do
      @current_path ""
      @api_definition Def.new
      unquote(block)
    end
  end

  defmacro path(p, do: block) do
    quote do
      @current_path @current_path <> "/" <> unquote(p)
      unquote(block)
      @current_path ""
    end
  end

  defmacro get(p, do: block) do
    quote do
      @previous_current_path @current_path
      @current_path @current_path <> "/" <> unquote(p)
      get(do: block)
      @current_path @previous_current_path
    end
  end
  defmacro get(do: block) do
    quote do
      endpoint = Endpoint.new(path: @current_path, verb: :get)
      new_def = Focus.over(
        Def.endpoints_lens, @api_definition, &(&1 ++ [endpoint])
      )
      @api_definition new_def
      @endpoint_idx length(new_def.endpoints) - 1
      unquote(block)
      @endpoint_idx nil
    end
  end

  defmacro query_param(key, type) do
    quote do
      query_param = QueryParam.new(key: unquote(key), type: unquote(type))
      lens = Def.endpoints_lens
        ~> Lens.idx(@endpoint_idx)
        ~> Endpoint.query_params_lens
      @api_definition Focus.over(lens, @api_definition, &(&1 ++ [query_param]))
    end
  end
end
