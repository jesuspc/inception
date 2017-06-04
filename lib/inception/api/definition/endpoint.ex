defmodule Inception.Api.Definition.Endpoint do
  import Lens
  deflenses path: "/", verb: :get, query_params: []

  def new(path: path, verb: verb) do
    %__MODULE__{path: path, verb: verb}
  end
end