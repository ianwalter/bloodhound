defmodule Mix.Tasks.Bloodhound.Index do
  use Mix.Task

  alias Bloodhound.Client

  def run(options) do
    mixfile = Mix.Project.get()
    {_, app} = Enum.at mixfile.project, 0

    {:ok, _} = Application.ensure_all_started :bloodhound

    case options do
      # [module_name] ->
        # Build Model and Repo modules
        # [app_module, _] = Module.split mixfile
        # repo = Module.concat app_module, Repo
        # model = Module.concat app_module, module_name

        # IO.inspect Code.load_binary(:elector)

        # apply(repo, :all, [model])

        # Get all model records
        # models = Mix.Project.in_project(:elector, ".", [], fn() -> repo.all(model) end)
        # models = repo.all model

        # Index each record
        # Enum.each models, &model.index/1

        # count = Enum.count models
        # Mix.shell.info [:green, "Indexed #{count} #{model.index_type}"]
    end
  end
end
