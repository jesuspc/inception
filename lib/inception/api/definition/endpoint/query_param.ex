defmodule Inception.Api.Definition.Endpoint.QueryParam do
  defstruct [:key, :type, :kind]

  def new(key: key, type: type, kind: kind) do
    %__MODULE__{key: key, type: type, kind: kind}
  end
end
