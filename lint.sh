#!/bin/sh

echo "Checking \"top-level\" script(s)..."
gdlint ./*.gd

echo "Checking \"launcher\" script(s)..."
gdlint launcher/*.gd

echo "Checking \"hud\" script(s)..."
gdlint hud/*.gd

echo "Checking \"example_*\" script(s)..."
gdlint example_*/*.gd
