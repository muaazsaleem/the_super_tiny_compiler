defmodule BadTokenError do
  defexception message: "Got a token I didn't understand"
end