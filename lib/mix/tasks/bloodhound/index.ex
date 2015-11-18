defmodule Mix.Tasks.Bloodhound.Index do
  use Mix.Task

#  alias Bloodhound.Client

  def run(options) do
    # {:ok, _} = Application.ensure_all_started :bloodhound

    case options do
      [module_name] ->
        # TODO http://stackoverflow.com/questions/33644132/how-can-i-make-a-module-from-the-current-project-available-inside-of-dependency/33644510#33644510

        # # Build Model and Repo modules
        # [app, _] = Module.split Mix.Project.get()
        # repo = Module.concat app, Repo
        # model = Module.concat app, module_name
        #
        # # Get all model records
        # models = repo.all model
        #
        # # Index each record
        # Enum.each models, &model.index/1
        #
        # count = Enum.count models
        # Mix.shell.info [:green, "Indexed #{count} #{model.index_type}"]
    end
  end
end
