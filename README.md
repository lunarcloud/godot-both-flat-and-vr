# Godot Example: Supporting Both Flat & XR
Get you a project template that can do both (XR and 'normal' 3D game).

This project example is using Godot 3.5.1

## Providing Launch Options

This is intended to be used with itch.io's [Manifest actions](https://itch.io/docs/itch/integrating/manifest-actions.html)" feature, where one can create different ways to launch a game. 

## Enforce XR Mode For Quest

Simply add the "always-xr" feature to the android export. 

Don't forget to setup the usual settings like "XR Mode" as "OpenXR".

![export-for-exclusively-xr-platform](screenshots/export-for-exclusively-xr-platform.jpg)

## Switchable XR / Flat Modes on Desktop

Use no argument, or "--xr=false", for standard flat mode.

![flat-command-option](screenshots/flat-command-option.jpg)

Use "--xr", or "--xr=true", for XR mode.

![xr-command-option](screenshots/xr-command-option.jpg)
