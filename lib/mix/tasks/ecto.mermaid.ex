defmodule Mix.Tasks.Ecto.Mermaid do
  use Mix.Task

  import Mix.Ecto

  @shortdoc "Creates a ERD diagram in Mermaid"
  @default_opts []

  @aliases [r: :repo]
  #   f: :force,
  #   q: :quiet,
  #   r: :repo
  # ]

  @switches [repo: [:keep, :string]]
  #   force: :boolean,
  #   force_drop: :boolean,
  #   quiet: :boolean,
  #   no_compile: :boolean,
  #   no_deps_check: :boolean
  # ]

  @impl true
  def run(args) do
    Application.ensure_all_started(:ecto)

    repos = parse_repo(args)
    {opts, _} = OptionParser.parse!(args, strict: @switches, aliases: @aliases)
    _opts = Keyword.merge(@default_opts, opts)

    Enum.each(repos, fn repo ->
      ensure_repo(repo, args)
      path = slug_repo_name(repo)

      Ecto.Migrator.with_repo(repo, fn repo ->
        build_erd(repo, path)
      end)
    end)
  end

  defp slug_repo_name(repo) do
    slug_name =
      repo
      |> to_string()
      |> String.downcase()
      |> String.trim_leading("elixir.")
      |> String.replace(".", "_")

    slug_name <> ".md"
  end

  defp build_erd(repo, path) do
    case EctoMermaid.build_erd(repo, path) do
      :ok ->
        Mix.shell().info("#{repo} diagram done in #{path}")

      {:error, error} ->
        Mix.shell().error(error)
    end
  end
end
