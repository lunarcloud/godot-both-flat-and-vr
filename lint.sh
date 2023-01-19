#!/bin/sh

echo "Checking \"launcher\" script(s)"
gdlint launcher/*.gd

echo "Checking \"hud\" script(s)"
gdlint hud/*.gd

echo "Checking \"example_*\" script(s)"
gdlint example_*/*.gd
