class Outbox
  var _pending: Array[String] iso = recover iso Array[String] end
  fun ref enqueue(note: String) => _pending.push(note)
  fun ref drain(): Array[String] iso^ =>
    _pending = recover iso Array[String] end

actor Main
  new create(env: Env) =>
    let draft: Array[String] trn = recover trn Array[String] end
    draft.push("first")
    let view: Array[String] box = draft
    env.out.print(view.size().string())
    let frozen: Array[String] val = consume val draft
    env.out.print(frozen.size().string())
    let outbox: Outbox ref = Outbox
    outbox.enqueue("queued")
    let parcel: Array[String] iso = outbox.drain()
    env.out.print(parcel.size().string())
    let empty: Array[String] iso = outbox.drain()
    env.out.print(empty.size().string())
