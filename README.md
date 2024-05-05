# EctoMermaid

Converts your Ecto Repo into a Mermaid ER diagram file

> [!WARNING]
> For now it only supports PostgreSQL and SQLite3 repos

## Installation

Add `:ecto_mermaid` to the list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ecto_mermaid, "~> 0.1.0", only: :dev}
  ]
end
```

## Usage

You can create a Markdown file with a Mermaid ER Diagram for each of the repos in your project.

```bash
mix ecto.mermaid
```

You can specify a single repo with the `-r` or `--repo` args:

```bash
mix ecto.mermaid -r MyApp.Repo
```
