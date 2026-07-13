use "cli"

class val DbConfig
  """
  PostgreSQL connection settings, read from environment variables with local
  defaults. Mirrors the pattern used by the sibling `migrate` project.
  """
  let host: String
  let port: String
  let user: String
  let password: String
  let database: String

  new val create(vars: (Array[String] val | None)) =>
    let e = EnvVars(vars)
    host = try e("POSTGRES_HOST")? else "127.0.0.1" end
    port = try e("POSTGRES_PORT")? else "5432" end
    user = try e("POSTGRES_USERNAME")? else "postgres" end
    password = try e("POSTGRES_PASSWORD")? else "postgres" end
    database = try e("POSTGRES_DATABASE")? else "pony_todo_dev" end
