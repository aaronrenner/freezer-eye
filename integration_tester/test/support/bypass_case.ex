defmodule IntegrationTester.BypassCase do
  @moduledoc false
  use ExUnit.CaseTemplate

  setup [:start_bypass]

  defp start_bypass(%{bypass: true}) do
    {:ok, bypass: Bypass.open()}
  end

  defp start_bypass(_), do: :ok
end
