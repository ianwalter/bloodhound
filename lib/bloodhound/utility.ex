defmodule Bloodhound.Utility do

  require Logger

  def debug_piped(piped, message \\ nil) do
    case message do
      nil -> Logger.debug piped
      _ -> Logger.debug "#{message} #{piped}"
    end
    piped
  end

end
