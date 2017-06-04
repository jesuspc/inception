defmodule MyApi do
  use Inception.Api

  api_definition do
    path "users" do
      get do
        query_param "sort_by", :string, :optional
      end
      post do
        consumes [:json]
        produces [:csv]
        body do
          schema do
            type :object
            property :name, :string, :required
          end
        end
        # response 200
        # response 400
      end
      put do

      end
      delete do

      end
      head do

      end
      patch do

      end
    end
    path "accounts" do
      get do
      end
    end
  end

  def get_schema do
    @api_definition
  end
end
