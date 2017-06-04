defmodule Inception.Api.Definition.Endpoint.Format do
  defstruct [:label]

  def new(label) do
    %__MODULE__{label: label}
  end
end
