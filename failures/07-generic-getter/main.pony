class Slot[A]
  let _value: A
  new create(value: A) => _value = consume value
  fun box get(): A => _value
actor Main
  new create(env: Env) => None
