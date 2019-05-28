# FreezerEye

Nerves app that sends a heartbeat to https://io.adafruit.io to let me know if
the freezer loses power.


## App design

This app is designed as a [poncho project][poncho_project], meaning the
components of the app are linked together using path-based dependencies instead
of the umbrella app's `app/<app_name>` folder structure.

The project is made up of the following libraries:

* [`freezer_eye`](freezer_eye): Main application logic of freezer_eye.
* [`fe_reporting`](fe_reporting): Internal application that manages how
  freezer_eye interacts with the chosen reporting service. The default
  implementation connects to [io.adafruit.com](adafruit-io), but can be easily
  migrated to another service.
* [`adafruit_io_http_client`](adafruit_io_http_client): This is a basic API
  client for the [Adafruit IO HTTP API][adafruit io http api].

There is also an [`integration_tester`](integration_tester) project which tests
the full application, mocking the outer boundaries of the application only as
needed. This gets run on the CI pipeline as well.

The dependency tree looks like this:

```
freezer_eye
├── fe_test_helpers (../fe_test_helpers)
└── fe_reporting (../fe_reporting)
    └── adafruit_io_http_client (../adafruit_io_http_client)
```

[poncho_project]: https://embedded-elixir.com/post/2017-05-19-poncho-projects/
[adafruit-io]: https://io.adafruit.com
[adafruit io http api]: https://io.adafruit.com/api/docs/
