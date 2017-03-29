# elixir_file_read_eager_lazy_flow

---

MapReduce 300,000 lines JSON file concurrently with Flow, GenStage

## Setup

```
$ mix do deps.get, compile
```

## Run IEx

```
$ iex -S mix
```

## Feel how fast Flow(GenStage) is!

```
$ iex> Reader.read :eager
or
$ iex> Reader.read :lazy
or
$ iex> Reader.read :flow
```

- `:eager` ... single thread
- `:lazy` ... single thread
- `:flow` ... multi thread!!
