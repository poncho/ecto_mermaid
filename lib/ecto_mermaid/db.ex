defmodule EctoMermaid.Db do
  @moduledoc false

  @doc """
  Returns all tables from the given Repo DB
  """
  @spec tables(module()) :: [String.t()]
  def tables(repo) do
    {:ok, %{rows: rows}} = repo.query("SELECT * FROM information_schema.tables;")

    for [_, "public", table | _] <- rows, table != "schema_migrations", do: table
  end
end
