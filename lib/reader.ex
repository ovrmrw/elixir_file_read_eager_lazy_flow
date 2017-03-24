defmodule JSON do
  def decode(json) do
    Poison.Parser.parse!(json, keys: :atoms)
  end
end


defmodule Eager do  
  def read do
    start_time = MyTime.timestamp

    list = 
      File.stream!("RandomUsers/names_300000.json")
      |> Enum.map(&JSON.decode(&1))
      |> Enum.map(fn person -> 
        %{name: %{first: first}} = person 
        first
      end)
      |> Enum.reduce(%{}, fn name, acc ->
        Map.update(acc, name, 1, & &1 + 1)
      end)
      |> Enum.sort(fn {_, count1}, {_, count2} -> count1 >= count2 end)
      |> Enum.to_list
    
    list
    |> IO.inspect    

    Enum.count(list) 
    |> IO.inspect

    (MyTime.timestamp - start_time) / 1000
  end
end


defmodule Lazy do
  def read do
    start_time = MyTime.timestamp

    list = 
      File.stream!("RandomUsers/names_300000.json")
      |> Stream.map(&JSON.decode(&1))
      |> Stream.map(fn person -> 
        %{name: %{first: first}} = person 
        first
      end)
      |> Enum.reduce(%{}, fn name, acc ->
        Map.update(acc, name, 1, & &1 + 1)
      end)
      |> Enum.sort(fn {_, count1}, {_, count2} -> count1 >= count2 end)
      |> Enum.to_list
    
    list
    |> IO.inspect    

    Enum.count(list) 
    |> IO.inspect

    (MyTime.timestamp - start_time) / 1000
  end
end


defmodule LazyFlow do
  def read do
    start_time = MyTime.timestamp

    list = 
      File.stream!("RandomUsers/names_300000.json")
      |> Flow.from_enumerable
      |> Flow.map(&JSON.decode(&1))
      |> Flow.map(fn person -> 
        %{name: %{first: first}} = person 
        first
      end)
      |> Flow.partition
      |> Flow.reduce(fn -> %{} end, fn name, acc ->
        Map.update(acc, name, 1, & &1 + 1)
      end)
      |> Enum.sort(fn {_, count1}, {_, count2} -> count1 >= count2 end)
      |> Enum.to_list
    
    list
    |> IO.inspect    

    Enum.count(list) 
    |> IO.inspect

    (MyTime.timestamp - start_time) / 1000
  end
end
