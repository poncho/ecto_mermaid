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

    # TODO: Maybe use data_type for some types that look better
    for [name, _data_type, udt_name] <- rows, do: {name, udt_name}
  end
end
