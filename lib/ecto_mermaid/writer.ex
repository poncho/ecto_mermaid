defmodule EctoMermaid.Writer do
  @moduledoc false

  @spec open_mermaid(File.io_device()) :: :ok
  def open_mermaid(file) do
    IO.write(file, "```mermaid\n")
  end

  @spec close_mermaid(File.io_device()) :: :ok
  def close_mermaid(file) do
    IO.write(file, "```")
  end

  @spec add_title(File.io_device(), String.t()) :: :ok
  def add_title(file, title) do
    title = """
    ---
    title: #{title}
    ---

    erDiagram
    """

    IO.write(file, title)
  end

  @spec draw_table(File.io_device(), String.t(), [{String.t(), String.t()}]) :: :ok
  def draw_table(file, table_name, columns) do
    buffer = "#{tab(1)}#{table_name} {\n"

    buffer =
      Enum.reduce(columns, buffer, fn {column_name, column_type}, acc ->
        acc <> "#{tab(2)}#{column_type} #{column_name}\n"
      end)

    buffer = buffer <> "#{tab(1)}}\n\n"

    IO.write(file, buffer)
  end

  @spec draw_relationship(File.io_device(), String.t(), String.t()) :: :ok
  def draw_relationship(file, table_name, relationship) do
    IO.write(file, ~s/#{table_name} ||--|{ #{relationship} : ""\n/)
  end

  # It should be a macro tbh
  @spec tab(integer()) :: String.t()
  defp tab(1) do
    "\t"
  end

  @spec tab(integer()) :: String.t()
  defp tab(tab_level) do
    String.duplicate("\t", tab_level)
  end
end
