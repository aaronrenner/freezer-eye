defmodule AdafruitIOHTTPClient.ApiClientCase do
  @moduledoc false
  use ExUnit.CaseTemplate

  alias Plug.Conn
  alias Plug.Parsers

  setup [:start_bypass]

  using do
    quote do
      import unquote(__MODULE__)
    end
  end

  def bypass_url(%Bypass{port: port}, path \\ "") do
    "http://localhost:#{port}" |> URI.merge(path) |> to_string()
  end

  defp start_bypass(%{bypass: true}) do
    {:ok, bypass: Bypass.open()}
  end

  defp start_bypass(_), do: :ok

  def parse_params(%Conn{} = conn) do
    Parsers.call(conn, Parsers.init(parsers: [:json], json_decoder: Jason))
  end
end
