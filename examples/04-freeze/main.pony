class Notebook
  let _notes: Array[String] = Array[String]
  fun ref add(note: String) => _notes.push(note)
  fun box snapshot(): Array[String] val =>
    let result = recover trn Array[String] end
    for note in _notes.values() do result.push(note) end
    consume val result

actor Main
  new create(env: Env) =>
    let book: Notebook ref = Notebook
    book.add("first")
    let frozen = book.snapshot()
    book.add("second")
    env.out.print(frozen.size().string())
    let built: Array[String] val = recover val
      let notes = Array[String]
      notes.push("built inside recover")
      notes
    end
    env.out.print(built.size().string())
