defmodule EctoMermaid.Adapters.Sqlite3 do
  @moduledoc false

  @behaviour EctoMermaid.Adapter

  @impl true
  def tables(repo) do
    query = """
    SELECT name FROM sqlite_master
    WHERE type = 'table'
    AND name NOT LIKE 'sqlite_%'
    """

    {:ok, %{rows: rows}} = repo.query(query)

    for [table] <- rows, table != "schema_migrations", do: table
  end

  @impl true
  def columns(repo, table_name) do
    query = """
    SELECT name, type FROM pragma_table_info('#{table_name}')
    """

    {:ok, %{rows: rows}} = repo.query(query)

    for [name, type] <- rows, do: {name, type}
  end

  def relationships(repo, table_name) do
    query = """
    SELECT * FROM pragma_foreign_key_list('#{table_name}');
    """

    {:ok, %{rows: rows}} = repo.query(query)

    for [fk] <- rows do
      ""
    end

    []
  end
end
