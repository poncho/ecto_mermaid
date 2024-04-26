defmodule EctoMermaid do
  @moduledoc """
  Documentation for `EctoMermaid`.
  """

  alias EctoMermaid.{
    Db,
    Writer
  }

  @spec build_erd(module(), Path.t()) :: :ok | {:error, String.t()}
  def build_erd(repo, path) do
    repo
    |> new(path)
    |> add_tables(repo)
    |> close()
  end

  @spec new(module(), Path.t()) :: File.io_device()
  defp new(repo, path) do
    file = File.open!(path, [:write, :utf8])

    :ok = Writer.open_mermaid(file)

    :ok = Writer.add_title(file, repo)

    file
  end

  defp add_tables(file, repo) do
    tables = Db.tables(repo)

    Enum.each(tables, fn table_name ->
      add_table(file, repo, table_name)
    end)

    file
  end

  defp add_table(file, repo, table_name) do
    columns = Db.columns(repo, table_name)
    Writer.draw_table(file, table_name, columns)
  end

  defp close(file) do
    Writer.close_mermaid(file)
    File.close(file)
  end
end
