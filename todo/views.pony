use stallion = "stallion"

primitive Layout
  """
  Wraps page-specific body HTML in the full HTML document, linking the
  Tailwind-generated stylesheet.
  """
  fun render(title: String, body: String): String =>
    "<!DOCTYPE html>\n"
      + "<html lang=\"en\">\n"
      + "<head>\n"
      + "<meta charset=\"utf-8\">\n"
      + "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n"
      + "<title>" + title + "</title>\n"
      + "<link rel=\"stylesheet\" href=\"/assets/app.css\">\n"
      + "</head>\n"
      + "<body class=\"min-h-screen bg-slate-50 text-slate-900\">\n"
      + body
      + "\n</body>\n</html>\n"

primitive HomePage
  """
  The placeholder home page for Task 2 — its only job is to prove Tailwind
  classes take effect. The real todo UI arrives in later tasks.
  """
  fun render(): String =>
    "<main class=\"mx-auto max-w-lg px-6 py-16\">"
      + "<h1 class=\"text-3xl font-bold tracking-tight\">Todo</h1>"
      + "<p class=\"mt-3 text-slate-600\">"
      + "Hello from the todo app &mdash; now styled with Tailwind."
      + "</p>"
      + "<span class=\"mt-6 inline-block rounded-md bg-indigo-600 px-4 py-2 "
      + "text-sm font-medium text-white shadow-sm\">Styled element</span>"
      + "</main>"

primitive Html
  """
  Small response helpers shared by handlers.
  """
  fun headers(): stallion.Headers val =>
    """
    Headers for an HTML response. Content-Length is added by the connection.
    """
    recover val
      let h = stallion.Headers
      h.add("Content-Type", "text/html; charset=utf-8")
      h
    end
