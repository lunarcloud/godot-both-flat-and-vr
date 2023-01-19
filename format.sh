#!/bin/sh

echo "Formatting \"top-level\" script(s)..."
gdformat ./*.gd

echo "Formatting \"launcher\" script(s)..."
gdformat launcher/*.gd

echo "Formatting \"hud\" script(s)..."
gdformat hud/*.gd

echo "Formatting \"example_*\" script(s)..."
gdformat example_*/*.gd
