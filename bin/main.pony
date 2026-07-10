use "files"
use hobby = "hobby"
use stallion = "stallion"
use lori = "lori"
use "../todo"

actor Main is hobby.ServerNotify
  let _env: Env

  new create(env: Env) =>
    _env = env
    let auth = lori.TCPListenAuth(env.root)
    let assets = FilePath(FileAuth(env.root), "assets")
    let app = hobby.Application
      .> get(
        "/",
        {(ctx) =>
          hobby.RequestHandler(consume ctx)
            .respond_with_headers(
              stallion.StatusOK,
              Html.headers(),
              Layout.render("Todo", HomePage.render()))
        } val)
      .> get("/assets/*filepath", hobby.ServeFiles(assets))

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
