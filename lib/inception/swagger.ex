defmodule Inception.Swagger do
  def build(module) do
    schema = module.get_schema
  end
end
