defmodule Mix.Tasks.Bloodhound do
  defmodule Delete do
    use Mix.Task

    alias Bloodhound.Client

    def run(options) do
      case options do
        [] -> Client.delete
        [module_name] ->
          {module, _} = Code.eval_string(module_name)
          module.delete_index
        [module_name, id] ->
          {module, _} = Code.eval_string(module_name)
          module.delete_index id
      end
    end
  end
end
