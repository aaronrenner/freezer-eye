# FreezerEyeFW

Nerves firmware for FreezerEye

## Development

## Handling secrets

In order to keep secrets out of source control, this project keeps its development settings in an optional config.secret.exs.

    cp config/config.secret.exs.template config/config.secret.exs

Once the template is copied, update them with your desired settings.

## Building the project

1. `export MIX_TARGET=rpi0` - To set the target you're compiling for
2. `mix deps.get` - Fetch the dependencies
3. `mix firmware` - Build the firmware
4. `mix firmware.burn` or `./upload.sh` to burn the program onto a SD card
   or do an OTA update, respectively.
