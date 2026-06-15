# Simple Waystone

Simple Waystone is a lightweight vanilla Minecraft datapack for a simple waystone / teleport marker system.

The project targets **Minecraft Java Edition 26.1.2** and data pack format **101.1**. It is designed primarily for server-side use on vanilla-compatible servers, with no client mod, plugin, or external dependency required.

## Status

Early development. This repository currently contains the datapack foundation and safe placeholder functions only. The full waystone system has not been implemented yet.

## Installation

1. Download or clone this repository.
2. Copy the datapack folder into your world's `datapacks/` directory.
3. Start or reload the world.
4. Run `/reload` if the world is already running.
5. Confirm the datapack is enabled with `/datapack list`.

## Planned Direction

- Keep the system small and readable.
- Prefer vanilla commands and datapack features.
- Add simple server-side waystone registration and teleport behavior.
- Avoid heavy per-tick logic unless a feature clearly requires it.
- Keep files clean enough for public distribution.

## Target Version

- Minecraft Java Edition: 26.1.2
- Data pack format: 101.1

## License

MIT License. See [LICENSE](LICENSE).
