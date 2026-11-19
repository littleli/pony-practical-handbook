interface box Counted
  fun box size(): USize

trait box Named
  fun box name(): String

class Notebook is Named
  let _notes: Array[String] = Array[String]
  fun ref add(note: String) => _notes.push(note)
  fun box size(): USize => _notes.size()
  fun box name(): String => "Pony lab"
  fun box first(): (String | None) =>
    try _notes(0)? else None end

primitive Describe
  fun apply(value: (Named box & Counted box)): String =>
    value.name() + ": " + value.size().string()

actor Main
  new create(env: Env) =>
    let book: Notebook ref = Notebook
    book.add("Understand unions")
    env.out.print(Describe(book))
    match book.first()
    | let note: String => env.out.print(note)
    | None => env.out.print("empty")
    end
    let pair: (String, USize) = (book.name(), book.size())
    env.out.print(pair._1 + ": " + pair._2.string())
