defmodule EctoMermaid.Adapter do
  @moduledoc false

  @type repo :: module()

  @callback tables(repo) :: [String.t()]

  @callback columns(repo, String.t()) :: [{String.t(), String.t()}]
end
