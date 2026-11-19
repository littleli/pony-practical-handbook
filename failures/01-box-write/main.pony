class Notebook
  var count: USize = 0
  fun ref add() => count = count + 1
actor Main
  new create(env: Env) =>
    let book: Notebook ref = Notebook
    let view: Notebook box = book
    view.add()
