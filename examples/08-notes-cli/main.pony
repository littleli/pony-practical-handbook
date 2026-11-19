use "collections"

class Notebook
  let _notes: Array[String] = Array[String]
  fun ref add(note: String) => _notes.push(note)
  fun box snapshot(): Array[String] val =>
    let result = recover trn Array[String] end
    for note in _notes.values() do result.push(note) end
    consume val result

actor Printer
  let _out: OutStream
  new create(out: OutStream) => _out = out
  be show(notes: Array[String] val) =>
    for note in notes.values() do _out.print(note) end
    _out.print("Total: " + notes.size().string())

actor Main
  new create(env: Env) =>
    if env.args.size() == 1 then
      env.out.print("Usage: notes <note> [<note> ...]")
      return
    end
    let book: Notebook ref = Notebook
    for i in Range[USize].till(1, env.args.size()) do
      try book.add(env.args(i)?) end
    end
    let frozen: Array[String] val = book.snapshot()
    Printer(env.out).show(frozen)
