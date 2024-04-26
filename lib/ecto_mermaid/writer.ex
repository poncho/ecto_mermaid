defmodule EctoMermaid.Writer do
  def open_mermaid(file) do
    IO.write(file, "```mermaid\n")
  end

  def close_mermaid(file) do
    IO.write(file, "```")
  end

  def add_title(file, title) do
    title = """
    ---
    title: #{title}
    ---

    erDiagram
    """

    IO.write(file, title)
  end

  def draw_table(file, table_name, columns) do
    buffer = "\t#{table_name} {\n"

    buffer =
      Enum.reduce(columns, buffer, fn {column_name, column_type}, acc ->
        acc <> "\t\t#{column_type} #{column_name}\n"
      end)

    buffer = buffer <> "}\n\n"

    IO.write(file, buffer)
  end
end
