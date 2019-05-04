Mox.defmock(FEReporting.AdafruitIOHTTPImpl.MockAdafruitIOHTTPClient,
  for: AdafruitIOHTTPClient.Impl
)

Application.put_env(
  :adafruit_io_http_client,
  :impl,
  FEReporting.AdafruitIOHTTPImpl.MockAdafruitIOHTTPClient
)

Mox.defmock(FEReporting.AdafruitIOHTTPImpl.MockConfig,
  for: FEReporting.AdafruitIOHTTPImpl.Config.Impl
)

Application.put_env(
  :fe_reporting,
  :adafruit_io_config_impl,
  FEReporting.AdafruitIOHTTPImpl.MockConfig
)

ExUnit.start()
