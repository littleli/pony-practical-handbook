class Notebook
  let title: String
  let _notes: Array[String] = Array[String]

  new create(title': String) =>
    title = title'

  fun ref add(note: String) =>
    _notes.push(note)

  fun box size(): USize =>
    _notes.size()

actor Main
  new create(env: Env) =>
    let book: Notebook ref = Notebook("Pony lab")
    let same_book: Notebook ref = book
    same_book.add("Understand ref")
    env.out.print(book.title + ": " + book.size().string())
