use "postgres"
use lori = "lori"

actor Db is (SessionStatusNotify & ResultReceiver)
  """
  Owns the single connection to PostgreSQL.

  The postgres driver is asynchronous: constructing a `Session` does not block
  or return a ready connection. We learn we are connected via the
  `pg_session_authenticated` callback, and query results arrive via
  `pg_query_result` / `pg_query_failed` — never as return values. This actor
  implements both notify interfaces so the driver can call back into it.

  Task 3 scope: connect, run one hardcoded `SELECT 42`, and log the result to
  prove the async flow end-to-end. Later tasks turn this into a real query
  service for the todo app.
  """
  let _out: OutStream
  var _session: (Session | None) = None

  new create(auth: lori.TCPConnectAuth, config: DbConfig, out: OutStream) =>
    _out = out
    // AllowAnyAuth so a local server using trust/md5 connects; the driver
    // otherwise defaults to AuthRequireSCRAM and would reject it.
    _session = Session(
      ServerConnectInfo(auth, config.host, config.port
        where auth_requirement' = AllowAnyAuth),
      DatabaseConnectInfo(config.user, config.password, config.database),
      this)

  be pg_session_authenticated(session: Session) =>
    _out.print("DB authenticated — running SELECT 42")
    session.execute(SimpleQuery("SELECT 42"), this)

  be pg_session_connection_failed(session: Session,
    reason: ConnectionFailureReason)
  =>
    _out.print("DB connection failed")

  be pg_query_result(session: Session, result: Result) =>
    match result
    | let rs: ResultSet =>
      _out.print("Query returned " + rs.rows().size().string() + " row(s)")
      try
        match rs.rows()(0)?.fields(0)?.value
        | let n: I32 => _out.print("First value (I32): " + n.string())
        else
          _out.print("First value: (unexpected type)")
        end
      end
    else
      _out.print("Query ok (non-ResultSet)")
    end
    session.close()

  be pg_query_failed(session: Session, query: Query,
    failure: (ErrorResponseMessage | ClientQueryError))
  =>
    match failure
    | let e: ErrorResponseMessage =>
      _out.print("Query failed: [" + e.severity + "] " + e.code + ": "
        + e.message)
    | let e: ClientQueryError =>
      _out.print("Query failed: client error")
    end
    session.close()
