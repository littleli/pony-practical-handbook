actor Archivist
  let _out: OutStream
  new create(out: OutStream) => _out = out
  be accept(notes: Array[String] iso) =>
    // Keep mutable state local after receiving ownership.
    let local: Array[String] ref = consume notes
    local.push("archived")
    _out.print(local.size().string())

actor Main
  new create(env: Env) =>
    let archive: Archivist tag = Archivist(env.out)
    let parcel: Array[String] iso = recover iso
      let notes = Array[String]
      notes.push("first")
      notes
    end
    archive.accept(consume parcel)
