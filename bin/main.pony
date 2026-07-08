use hobby = "hobby"
use stallion = "stallion"
use lori = "lori"

actor Main is hobby.ServerNotify
  let _env: Env

  new create(env: Env) =>
    _env = env
    let auth = lori.TCPListenAuth(env.root)
    let app = hobby.Application
      .> get(
        "/",
        {(ctx) =>
          hobby.RequestHandler(consume ctx)
            .respond(stallion.StatusOK, "Hello from the todo app!")
        } val)

    match \exhaustive\ app.build()
    | let built: hobby.BuiltApplication =>
      hobby.Server(auth, built, this where host = "0.0.0.0", port = "8080")
    | let err: hobby.ConfigError =>
      env.err.print(err.message)
    end

  be listening(server: hobby.Server, host: String, service: String) =>
    _env.out.print("Listening on " + host + ":" + service)

  be listen_failed(server: hobby.Server, reason: String) =>
    _env.err.print(reason)
