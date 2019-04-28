defmodule AdafruitIOHTTPClient.TeslaImplTest do
  use AdafruitIOHTTPClient.ApiClientCase, async: true
  use ExUnitProperties

  import Plug.Conn

  alias AdafruitIOHTTPClient.Config
  alias AdafruitIOHTTPClient.Datapoint
  alias AdafruitIOHTTPClient.HTTPClientError
  alias AdafruitIOHTTPClient.TeslaImpl
  alias AdafruitIOHTTPClient.UnexpectedResponseFormatError
  alias AdafruitIOHTTPClient.UnexpectedStatusCodeError

  setup [:set_config_from_bypass]

  @moduletag :bypass
  @moduletag :capture_log

  test "create_datapoint/3 sends the proper request", %{
    bypass: bypass,
    config: %Config{username: username, secret_key: secret_key} = config
  } do
    feed_key = "foo"
    value = 1
    [response] = Enum.take(datapoint_response(), 1)

    Bypass.expect_once(bypass, "POST", "/api/v2/#{username}/feeds/#{feed_key}/data", fn conn ->
      conn = parse_params(conn)
      assert [^secret_key] = get_req_header(conn, "x-aio-key")
      assert ["application/json; charset=utf-8"] = get_req_header(conn, "content-type")
      assert %{"value" => value} == conn.params

      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(response))
    end)

    assert {:ok, _} = TeslaImpl.create_datapoint(feed_key, value, config: config)
  end

  test "create_datapoint/3 returns {:ok, %Datapoint{}} on 200 response", %{
    bypass: bypass,
    config: %Config{username: username} = config
  } do
    feed_key = "foo"
    [%{"id" => assigned_id, "value" => value} = response] = Enum.take(datapoint_response(), 1)

    Bypass.expect_once(bypass, "POST", "/api/v2/#{username}/feeds/#{feed_key}/data", fn conn ->
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(response))
    end)

    assert {:ok, %Datapoint{id: ^assigned_id, value: ^value}} =
             TeslaImpl.create_datapoint(feed_key, value, config: config)
  end

  test "create_datapoint/3 returns {:error, %HTTPClientError{}} when unable to connect", %{
    bypass: bypass,
    config: config
  } do
    Bypass.down(bypass)
    feed_key = "foo"
    value = 1

    assert {:error, %HTTPClientError{reason: :econnrefused}} =
             TeslaImpl.create_datapoint(feed_key, value, config: config)
  end

  test "create_datapoint/3 returns {:error, %UnexpectedStatusCodeError{}} with a non-200 status code",
       %{bypass: bypass, config: %Config{username: username} = config} do
    feed_key = "foo"
    value = 1

    Bypass.expect_once(bypass, "POST", "/api/v2/#{username}/feeds/#{feed_key}/data", fn conn ->
      conn
      |> send_resp(400, "{}")
    end)

    assert {:error, %UnexpectedStatusCodeError{}} =
             TeslaImpl.create_datapoint(feed_key, value, config: config)
  end

  test "create_datapoint/3 returns {:error, %UnexpectedResponseFormatError{}}", %{
    bypass: bypass,
    config: %Config{username: username} = config
  } do
    feed_key = "foo"
    value = 1

    Bypass.expect_once(bypass, "POST", "/api/v2/#{username}/feeds/#{feed_key}/data", fn conn ->
      conn
      |> send_resp(200, "{}")
    end)

    assert {:error, %UnexpectedResponseFormatError{}} =
             TeslaImpl.create_datapoint(feed_key, value, config: config)
  end

  defp set_config_from_bypass(%{bypass: %Bypass{} = bypass}) do
    [config: config_from_bypass(bypass)]
  end

  defp config_from_bypass(%Bypass{} = bypass) do
    %Config{username: "joedirt", secret_key: "mullet", base_url: bypass_url(bypass)}
  end

  defp datapoint_response do
    fixed_map(%{
      "id" => string(:alphanumeric),
      "value" => one_of([string(:alphanumeric), integer(), float()])
    })
  end
end
