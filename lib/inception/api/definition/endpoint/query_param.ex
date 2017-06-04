defmodule Inception.Api.Definition.Endpoint.QueryParam do
  defstruct [:key, :type]

  def new(key: key, type: type) do
    %__MODULE__{key: key, type: type}
  end
end
