defmodule Inception.Api do
  alias Inception.Api.Definition, as: Def
  alias Def.Endpoint, as: Endpoint
  alias Endpoint.QueryParam, as: QueryParam
  alias Endpoint.Format, as: Format
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

  defmacro action(p, verb, do: block) do
    quote do
      @previous_current_path @current_path
      @current_path @current_path <> "/" <> unquote(p)
      action(unquote(verb), do: block)
      @current_path @previous_current_path
    end
  end
  defmacro action(verb, do: block) do
    quote do
      endpoint = Endpoint.new(path: @current_path, verb: unquote(verb))
      new_def = Focus.over(
        Def.endpoints_lens, @api_definition, &(&1 ++ [endpoint])
      )
      @api_definition new_def
      @endpoint_idx length(new_def.endpoints) - 1
      unquote(block)
      @endpoint_idx nil
    end
  end

  defmacro get(p, do: block) do
    quote do
      action(unquote(p), :get, do: unquote(block))
    end
  end
  defmacro get(do: block) do
    quote do
      action(:get, do: unquote(block))
    end
  end

  defmacro post(p, do: block) do
    quote do
      action(unquote(p), :post, do: unquote(block))
    end
  end
  defmacro post(do: block) do
    quote do
      action(:post, do: unquote(block))
    end
  end

  defmacro put(p, do: block) do
    quote do
      action(unquote(p), :put, do: unquote(block))
    end
  end
  defmacro put(do: block) do
    quote do
      action(:put, do: unquote(block))
    end
  end

  defmacro delete(p, do: block) do
    quote do
      action(unquote(p), :delete, do: unquote(block))
    end
  end
  defmacro delete(do: block) do
    quote do
      action(:delete, do: unquote(block))
    end
  end

  defmacro head(p, do: block) do
    quote do
      action(unquote(p), :head, do: unquote(block))
    end
  end
  defmacro head(do: block) do
    quote do
      action(:head, do: unquote(block))
    end
  end

  defmacro patch(p, do: block) do
    quote do
      action(unquote(p), :patch, do: unquote(block))
    end
  end
  defmacro patch(do: block) do
    quote do
      action(:patch, do: unquote(block))
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

  defmacro consumes(formats) do
    quote do
      new_formats = Enum.map unquote(formats), &(Format.new(&1))
      lens = Def.endpoints_lens
      ~> Lens.idx(@endpoint_idx)
      ~> Endpoint.input_formats_lens
      @api_definition Focus.over(lens, @api_definition, &(&1 ++ new_formats))
    end
  end

  defmacro produces(formats) do
    quote do
      new_formats = Enum.map unquote(formats), &(Format.new(&1))
      lens = Def.endpoints_lens
      ~> Lens.idx(@endpoint_idx)
      ~> Endpoint.output_formats_lens
      @api_definition Focus.over(lens, @api_definition, &(&1 ++ new_formats))
    end
  end
end
