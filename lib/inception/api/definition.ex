defmodule Inception.Api.Definition do
  import Lens
  deflenses endpoints: []

  def new do
    new(endpoints: [])
  end
  def new(endpoints: endpoints) do
    %__MODULE__{endpoints: endpoints}
  end
end
