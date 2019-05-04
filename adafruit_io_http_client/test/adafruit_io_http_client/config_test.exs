defmodule AdafruitIOHTTPClient.ConfigTest do
  use ExUnit.Case

  alias AdafruitIOHTTPClient.Config

  @default_base_url "https://io.adafruit.com"

  test "new/1 sets default fields" do
    username = "foo"
    secret_key = "bar"

    assert %Config{
             username: username,
             secret_key: secret_key,
             base_url: @default_base_url
           } == Config.new(username, secret_key)
  end

  test "new/1 allows overriding the base_url" do
    username = "foo"
    secret_key = "bar"
    base_url = "http://www.example.com"

    assert %Config{
             username: username,
             secret_key: secret_key,
             base_url: base_url
           } == Config.new(username, secret_key, base_url: base_url)
  end

  test "load_from_env!/0 with all required settings" do
    ensure_setting_is_reset(:adafruit_io_http_client, :base_url)
    ensure_setting_is_reset(:adafruit_io_http_client, :username)
    ensure_setting_is_reset(:adafruit_io_http_client, :secret_key)
    base_url = "http://www.example.com"
    username = "foobar"
    secret_key = "secret"

    Application.put_env(:adafruit_io_http_client, :base_url, base_url)
    Application.put_env(:adafruit_io_http_client, :username, username)
    Application.put_env(:adafruit_io_http_client, :secret_key, secret_key)

    assert %Config{
             base_url: ^base_url,
             username: ^username,
             secret_key: ^secret_key
           } = Config.load_from_env!()
  end

  test "load_from_env!/0 when missing settings" do
    ensure_setting_is_reset(:adafruit_io_http_client, :base_url)
    ensure_setting_is_reset(:adafruit_io_http_client, :username)
    ensure_setting_is_reset(:adafruit_io_http_client, :secret_key)

    Application.delete_env(:adafruit_io_http_client, :base_url)
    Application.delete_env(:adafruit_io_http_client, :username)
    Application.delete_env(:adafruit_io_http_client, :secret_key)

    assert_raise ArgumentError, fn ->
      Config.load_from_env!()
    end
  end

  defp ensure_setting_is_reset(application, key) do
    original_result = Application.fetch_env(application, key)

    on_exit(fn ->
      case original_result do
        {:ok, original_value} ->
          Application.put_env(application, key, original_value)

        :error ->
          Application.delete_env(application, key)
      end
    end)
  end
end
