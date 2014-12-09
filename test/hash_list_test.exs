defmodule HashListTest do
  use ExUnit.Case

  test "HashList.new" do
    assert HashList.new != nil
  end

  test "HashList.put (basic)" do
    hl = HashList.new
    {key, hl} = hl |> HashList.push "hello"
    assert key != nil
    assert hl.storage |> HashDict.fetch(key) == {:ok, "hello"}

    {^key, hl} = hl |> HashList.put key, "bye"
    assert hl.storage |> HashDict.fetch(key) == {:ok, "bye"}
  end

  defp loop_push(hashlist, value, times) do
    {_, hashlist} = hashlist |> HashList.push value
    cond do
      times > 1 -> loop_push(hashlist, value, times - 1)
      true -> hashlist
    end
  end

  test "HashList.put/delete" do
    hl = HashList.new
    hl = hl |> loop_push "t", 5
    hl = hl |> HashList.delete 2
    {key, hl} = hl |> HashList.push "z"
    assert key == 2, "#{inspect hl}"
  end
end
