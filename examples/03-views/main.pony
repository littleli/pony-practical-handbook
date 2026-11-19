class Notebook
  let _notes: Array[String] = Array[String]
  fun ref add(note: String) => _notes.push(note)
  fun box size(): USize => _notes.size()
  fun box notes(): Array[String] box => _notes
  fun ref editable_notes(): Array[String] ref => _notes
  fun box first(): (String | None) =>
    try _notes(0)? else None end

actor Main
  new create(env: Env) =>
    let book: Notebook ref = Notebook
    let view: Notebook box = book
    book.add("box is a view")
    env.out.print(view.size().string())
    let edit = book.editable_notes()
    edit.push("let is not deep immutability")
    env.out.print(view.notes().size().string())
