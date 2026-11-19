actor Main
  new create(env: Env) =>
    let notes: Array[String] ref = Array[String]
    let frozen: Array[String] val = consume notes
