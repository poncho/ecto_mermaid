defmodule EctoMermaid.Adapter do
  @moduledoc false

  @typep repo :: module()
  @typep table_name :: String.t()

  @callback tables(repo) :: [String.t()]

  @callback columns(repo, table_name) :: [{String.t(), String.t()}]

  @callback relationships(repo, table_name) :: [String.t()]
end
