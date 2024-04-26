defmodule EctoMermaid.Repo do
  def slug(repo) when is_atom(repo) do
    repo
    |> to_string()
    |> String.downcase()
    |> String.trim_leading("elixir.")
    |> String.replace(".", "_")
  end
end
