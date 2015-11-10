defmodule Mix.Tasks.Bloodhound.Index do
  use Mix.Task

  alias Bloodhound.Client

  def run(options) do
    {:ok, _} = Application.ensure_all_started :bloodhound

    case options do
      [module_name] ->
        # Build Model and Repo modules
        [app, _] = Module.split Mix.Project.get()
        repo = Module.concat app, Repo
        model = Module.concat app, module_name

        # Get all model records
        models = repo.all model

        # Index each record
        Enum.each models, &model.index/1

        count = Enum.count models
        Mix.shell.info [:green, "Indexed #{count} #{model.index_type}"]
    end
  end
end
