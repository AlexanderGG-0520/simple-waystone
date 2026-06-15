# Design Notes

Simple Waystone is intended to be a small server-side waystone datapack for Minecraft Java Edition 26.1.2.

## Philosophy

- Stay compatible with vanilla Minecraft datapacks.
- Require no client mod, server plugin, or external dependency.
- Keep commands and functions minimal.
- Make the behavior readable for server operators who want to inspect or adjust it.
- Avoid heavy ticking logic unless a feature absolutely needs it.
- Keep the repository clean and suitable for public distribution.

## Initial Scope

The first version should focus on a simple waystone / teleport marker loop:

- define a waystone marker;
- let players use a clear vanilla interaction;
- teleport players through predictable server-side commands;
- keep state storage simple and inspectable.

The full gameplay system is intentionally not implemented in the repository foundation. This keeps the first commit focused on a valid datapack skeleton, documentation, and project hygiene.

## Target

- Minecraft Java Edition: 26.1.2
- Data pack format: 101.1
- Datapack namespace: `simple_waystone`
