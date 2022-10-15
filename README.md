# Godot Example: Supporting Both Flat & XR
![icon](icon.png)

Get you a project template that can do both (XR and 'normal' 3D game).

This project example is using Godot 3.5.1

## Providing Launch Options in Launcher App

This is intended to be used with itch.io's ["Manifest actions"](https://itch.io/docs/itch/integrating/manifest-actions.html) feature, where one can create different ways to launch a game. 

## Enforce XR Mode For Quest

Simply add the "always-xr" feature to the android export.

Don't forget to setup the usual settings like "XR Mode" as "OpenXR".

![export-for-exclusively-xr-platform](screenshots/export-for-exclusively-xr-platform.jpg)

## Autodetect
If no OS feature is enforcing a mode, or the in-engine selector, it will select a mode based on whether it can start in XR mode or not.

![auto-detect](screenshots/auto-detect.jpg)

## Specify Mode via argument

  * Use "--flat", "--flat=true", or "--xr=false" for standard flat mode.
  * Use "--xr" or "--xr=true" for XR mode.

![xr-command-option](screenshots/xr-command-option.jpg)
