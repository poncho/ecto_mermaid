defmodule EctoMermaid.Render do
  defstruct [
    :file,
    :repo,
    :db_render_adapter,
    :valid?
  ]

  @type t :: %__MODULE__{
          file: File.io_device(),
          repo: module(),
          db_render_adapter: module()
        }

  @spec new(File.io_device(), module()) :: __MODULE__.t() | {:error, String.t()}
  def new(file, repo) do
    ecto_adapter = repo.__adapter__()

    case db_render_adapter(ecto_adapter) do
      {:ok, adapter} ->
        %__MODULE__{
          file: file,
          repo: repo,
          db_render_adapter: adapter
        }

      :not_supported ->
        clean_adapter = remove_elixir_prefix(ecto_adapter)

        {:error, "Ecto adapter module #{clean_adapter} not supported"}
    end
  end

  @spec db_render_adapter(module()) :: {:ok, module()} | :not_supported
  defp db_render_adapter(Ecto.Adapters.Postgres) do
    {:ok, EctoMermaid.Adapters.Postgres}
  end

  defp db_render_adapter(_) do
    :not_supported
  end

  defp remove_elixir_prefix(module) do
    module
    |> Module.split()
    |> Enum.join(".")
  end
end
