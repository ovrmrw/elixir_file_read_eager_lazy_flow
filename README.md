# elixir_file_read_eager_lazy_flow

---

MapReduce with Flow, GenStage

## Setup

```
$ mix do deps.get, compile
```

## Run IEx

```
$ iex -S mix
```

## Feel how fast Flow is!

```
$ iex> Reader.read :eager
or
$ iex> Reader.read :lazy
or
$ iex> Reader.read :flow
```
