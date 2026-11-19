class Slot[A: Any #read]
  let _value: A
  new create(value: A) => _value = value
  fun box get(): this->A => _value

class Notebook
  let _notes: Array[String] = Array[String]
  fun ref add(note: String) => _notes.push(note)
  fun box size(): USize => _notes.size()

actor Main
  new create(env: Env) =>
    let book: Notebook ref = Notebook
    book.add("first")
    let slot = Slot[Notebook ref](book)
    let read: Notebook box = slot.get()
    env.out.print(read.size().string())
    let title = Slot[String val]("Pony lab")
    env.out.print(title.get())
