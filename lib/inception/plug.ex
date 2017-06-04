defmodule Inception.Plug do
  def build(module) do
    schema = module.get_schema
  end
end
