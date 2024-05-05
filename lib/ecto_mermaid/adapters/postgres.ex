defmodule EctoMermaid.Adapters.Postgres do
  @moduledoc false

  @behaviour EctoMermaid.Adapter

  @schema "public"

  @impl true
  def tables(repo) do
    query = "SELECT table_name FROM information_schema.tables WHERE table_schema = '#{@schema}'"
    {:ok, %{rows: rows}} = repo.query(query)

    for [table] <- rows, table != "schema_migrations", do: table
  end

  @impl true
  def columns(repo, table_name) do
    query = """
    SELECT column_name, data_type, udt_name
      FROM information_schema.columns
     WHERE table_schema = '#{@schema}'
       AND table_name   = '#{table_name}';
    """

    {:ok, %{rows: rows}} = repo.query(query)

    for [name, _data_type, udt_name] <- rows, do: {name, udt_name}
  end

  @impl true
  def relationships(repo, table_name) do
    query = """
    SELECT pg_catalog.pg_get_constraintdef(r.oid, true) as condef
    FROM pg_catalog.pg_constraint r
    WHERE r.conrelid = '#{@schema}.#{table_name}'::regclass
    AND r.contype = 'f';
    """

    {:ok, %{rows: rows}} = repo.query(query)

    for [fk] <- rows do
      [_, table] = Regex.run(~r/REFERENCES (\w+)/, fk)
      table
    end
  end
end
