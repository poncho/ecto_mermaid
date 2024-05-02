defmodule EctoMermaid do
  @moduledoc """
  Documentation for `EctoMermaid`.
  """

  alias EctoMermaid.{
    Render,
    Writer
  }

  @spec build_erd(module(), Path.t()) :: :ok | {:error, String.t()}
  def build_erd(repo, path) do
    case new(repo, path) do
      %Render{} = render ->
        do_build_erd(render)

      {:error, error} ->
        {:error, error}
    end
  end

  @spec do_build_erd(Render.t()) :: :ok
  defp do_build_erd(render) do
    render
    |> add_tables()
    |> close()
  end

  @spec new(module(), Path.t()) :: Render.t() | {:error, String.t()}
  defp new(repo, path) do
    file = File.open!(path, [:write, :utf8])

    :ok = Writer.open_mermaid(file)

    :ok = Writer.add_title(file, repo)

    Render.new(file, repo)
  end

  @spec add_tables(Render.t()) :: Render.t()
  defp add_tables(render) do
    tables = render.db_render_adapter.tables(render.repo)

    Enum.each(tables, fn table_name ->
      add_table(render, table_name)
    end)

    render
  end

  @spec add_table(Render.t(), String.t()) :: :ok
  defp add_table(render, table_name) do
    columns = render.db_render_adapter.columns(render.repo, table_name)
    :ok = Writer.draw_table(render.file, table_name, columns)

    add_relationships(render, table_name)
  end

  defp add_relationships(render, table_name) do
    render.repo
    |> render.db_render_adapter.relationships(table_name)
    |> Enum.each(fn relationship ->
      Writer.draw_relationship(render.file, table_name, relationship)
    end)

    render
  end

  @spec close(Render.t()) :: :ok
  defp close(render) do
    Writer.close_mermaid(render.file)
    File.close(render.file)
  end
end
