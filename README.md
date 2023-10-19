# Stairs Character

A simple to use class that enables your CharacterBody3D to handle stairs properly.

## Usage instructions:

1. Make your character controller extend `StairsCharacter` instead of `CharacterBody3D`.
2. Call `handle_stairs()` before calling `move_and_slide()`.
3. Done!

If your controller uses multiple colliders, make sure the one closest to the ground is the first in the list.
