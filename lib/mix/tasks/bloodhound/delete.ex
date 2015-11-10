defmodule Mix.Tasks.Bloodhound.Delete do
  use Mix.Task

  alias Bloodhound.Client

  def run(options) do
    {:ok, _} = Application.ensure_all_started :bloodhound

    case options do
      [] ->
        Client.delete
        index_name = Application.get_env :bloodhound, :index
        Mix.shell.info [:green, "Deleted #{index_name} index"]
      [module_name] ->
        {module, _} = Code.eval_string module_name
        module.delete_index
        Mix.shell.info [:green, "Deleted #{module.index_type} type"]
      [module_name, id] ->
        {module, _} = Code.eval_string module_name
        module.delete_index id
        Mix.shell.info [:green, "Deleted #{module.index_type} with ID #{id}"]
    end
  end
end
