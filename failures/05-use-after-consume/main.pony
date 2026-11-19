actor Main
  new create(env: Env) =>
    let parcel: Array[String] iso = recover iso Array[String] end
    let moved: Array[String] iso = consume parcel
    env.out.print(parcel.size().string())
