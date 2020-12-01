defmodule Helper do
  @moduledoc """
  Helper functions
  """

  def get_string_from_file(fileName) do
    {:ok, result} = File.read(fileName)
    result
  end

end
