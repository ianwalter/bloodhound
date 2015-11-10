defmodule Mix.Tasks.Bloodhound do
  defmodule Delete do
    use Mix.Task

    alias Bloodhound.Client

    def run(options) do
      {:ok, _} = Application.ensure_all_started(:bloodhound)

      case options do
        [] ->
          Client.delete
          IO.puts "Deleted #{Application.get_env :bloodhound, :index} index"
        [module_name] ->
          {module, _} = Code.eval_string(module_name)
          module.delete_index
          IO.puts "Deleted #{module.index_type} index"
        [module_name, id] ->
          {module, _} = Code.eval_string(module_name)
          module.delete_index id
          IO.puts "Deleted #{module.index_type}, #{id} index"
      end
    end
  end
end
