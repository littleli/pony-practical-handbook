class Notebook
  let _notes: Array[String] = Array[String]
  fun box notes(): Array[String] ref => _notes
actor Main
  new create(env: Env) => None
