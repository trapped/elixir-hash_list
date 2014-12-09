defmodule HashList do
  defstruct reuse_indexes: true, last_index: nil, random_indexes: false, storage: nil

  def new(opts \\ []) do
    %HashList{
      storage: HashDict.new
    }
  end

  def put(hashlist, key, value) do
    unless key do
      key = HashList.next_key(hashlist)
    end
    {key, %HashList{hashlist | storage: HashDict.put(hashlist.storage, key, value), last_index: key}}
  end

  def push(hashlist, value) do
    put(hashlist, nil, value)
  end

  def next_key(hashlist) do
    case hashlist do
      %HashList{random_indexes: true} ->
        hashlist |> next_random
      %HashList{reuse_indexes: true} ->
        hashlist |> next_reused
      %HashList{reuse_indexes: false} ->
        hashlist |> next_contiguous
    end
  end

  defp next_random(hashlist) do
    random = :random.uniform(:math.pow(2, 32)) - 1
    if HashDict.has_key?(hashlist.storage, random) do
      next_random(hashlist)
    else
      random
    end
  end

  defp next_reused(hashlist) do
    reduce_break(hashlist.storage |> HashDict.keys |> Enum.sort, &(&1 != (&2 - 1)))
  end

  defp next_contiguous(hashlist) do
    hashlist.last_index + 1
  end

  defp reduce_break(keys, condition, last \\ -1) do
    case keys do
      [] -> 0
      [i] ->
        unless condition.(last, i) do
          i + 1
        else
          i - 1
        end
      [next | rest] ->
        unless condition.(last, next) do
          reduce_break(rest |> Enum.sort, condition, next)
        else
          next - 1
        end
    end
  end

  def delete(hashlist, key) do
    %HashList{hashlist | storage: HashDict.delete(hashlist.storage, key)}
  end

  def fetch(hashlist, key) do
    HashDict.fetch(hashlist.storage, key)
  end

  def size(hashlist) do
    HashDict.size(hashlist.storage)
  end

  def to_list(hashlist) do
    HashDict.to_list(hashlist.storage)
  end
end

defimpl Enumerable, for: HashList do
  def reduce(dict, acc, fun), do: HashDict.reduce(dict.storage, acc, fun)
  def member?(dict, {k, v}),  do: {:ok, match?({:ok, ^v}, HashList.fetch(dict.storage, k))}
  def member?(_dict, _),    do: {:ok, false}
  def count(dict),      do: {:ok, HashList.size(dict.storage)}
end

defimpl Access, for: HashList do
  def get(dict, key) do
    HashDict.get(dict.storage, key, nil)
  end

  def get_and_update(dict, key, fun) do
    {get, update} = fun.(HashDict.get(dict.storage, key, nil))
    {get, HashList.put(dict, key, update)}
  end
end

defimpl Collectable, for: HashList do
  def empty(_dict) do
    HashList.new
  end

  def into(original) do
    {original, fn
      dict, {:cont, {k, v}} -> Dict.put(dict, k, v)
      dict, :done -> dict
      _, :halt -> :ok
    end}
  end
end

defimpl Inspect, for: HashList do
  import Inspect.Algebra

  def inspect(dict, opts) do
    concat ["#HashList<", Inspect.List.inspect(HashList.to_list(dict) |> Enum.sort, opts), ">"]
  end
end
