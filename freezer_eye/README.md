# FreezerEye

Business logic for FreezerEye Nerves app.

## Handling secrets in development

In order to keep secrets out of source control, this project keeps its development settings in an optional dev.secret.exs.

    cp config/dev.secret.exs.template config/dev.secret.exs

Once the template is copied, update them with your desired settings.
