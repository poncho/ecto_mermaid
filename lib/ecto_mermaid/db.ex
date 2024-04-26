defmodule EctoMermaid.Db do
  @moduledoc false

  @schema "public"

  @doc """
  Returns all tables from the given Repo DB
  """
  @spec tables(module()) :: [String.t()]
  def tables(repo) do
    query = "SELECT table_name FROM information_schema.tables WHERE table_schema = '#{@schema}'"
    {:ok, %{rows: rows}} = repo.query(query)

    for [table] <- rows, table != "schema_migrations", do: table
  end

  def columns(repo, table_name) do
    query = """
    SELECT column_name, data_type, udt_name
      FROM information_schema.columns
     WHERE table_schema = '#{@schema}'
       AND table_name   = '#{table_name}';
    """

    {:ok, %{rows: rows}} = repo.query(query)

    # TODO: Maybe use data_type for some types that look better
    for [name, _data_type, udt_name] <- rows, do: {name, udt_name}
  end
end
