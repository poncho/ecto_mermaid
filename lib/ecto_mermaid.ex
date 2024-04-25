defmodule EctoMermaid do
  @moduledoc """
  Documentation for `EctoMermaid`.
  """

  alias EctoMermaid.Db

  @spec build_erd(module(), Path.t()) :: :ok | {:error, String.t()}
  def build_erd(repo, _path) do
    tables = Db.tables(repo)

    IO.inspect(tables)
    :ok
  end
end
