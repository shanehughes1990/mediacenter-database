# mediacenter-database Copilot Instructions

## Purpose
This repository is a **Profilarr Compliant Database (PCD)** used by `Dictionarry-Hub/profilarr` as a source of truth for Sonarr/Radarr configuration data.

All changes must preserve **PCD compatibility**, **cross-file name references**, and **predictable sync behavior**.

## Primary Scope
- Build and maintain custom formats, regex patterns, quality profiles, and media-management YAML used for Radarr/Sonarr sync.
- Keep edits minimal, schema-correct, and consistent with existing repository conventions.

## Repository Structure (authoritative)
- `custom_formats/` → Custom format definitions (conditions + optional tests)
- `regex_patterns/` → Reusable regex entities referenced by custom format conditions
- `profiles/` → Quality profiles and scoring maps
- `media_management/` → Naming, quality definitions, misc media settings
- `templates/` → Pattern templates for generating new entities
- `scripts/` → Utility scripts for generation/maintenance

## Critical Rules
1. **Treat `name` as an ID/key.**
	- `name` values are effectively primary identifiers across files.
	- Do not rename entities unless explicitly requested.
	- If renaming is requested, update all references in profiles/custom formats.

2. **Preserve YAML shape used by existing files.**
	- Keep key ordering/style aligned with neighboring files.
	- Do not introduce new schema fields unless explicitly requested.

3. **Keep references resolvable.**
	- `profiles/*.yml` custom format names must exist in `custom_formats/`.
	- Regex condition `pattern` names must exist in `regex_patterns/` when used as reusable regex entities.

4. **Respect Profilarr behavior.**
	- Profilarr compiles reusable regex + conditions into Arr-native custom formats on sync.
	- One Arr instance syncs from one database; profile dependencies pull required custom formats.

5. **Regex expectations.**
	- Write patterns compatible with .NET regex behavior used by Profilarr parser flow.
	- Prefer precise, bounded patterns over broad/greedy matching.

## Editing Guidance by File Type
- `custom_formats/*.yml`
  - Typical fields: `name`, `description`, `tags`, `conditions`, `tests`.
  - Each condition must include coherent `type`, `required`, and `negate` behavior.

- `regex_patterns/*.yml`
  - Keep `name`, `pattern`, `tags`, and optional `description` accurate and reusable.

- `profiles/*.yml`
  - Keep scoring intentional and explicit.
  - Preserve sections used today (`custom_formats`, `custom_formats_radarr`, `custom_formats_sonarr`, `qualities`, `upgrade_until`, etc.) when present.

- `media_management/*.yml`
  - Keep Radarr/Sonarr structures explicit and avoid implicit defaults.

## What Copilot Should Do for Changes
- Read related files first, then make the smallest possible edit.
- Validate name references after edits (especially profile ↔ custom format and condition ↔ regex links).
- Avoid broad refactors, file moves, or mass reformatting unless explicitly asked.
- If requirements are ambiguous, choose the simplest schema-consistent interpretation.

## Commit Message Preference
Follow repository convention:
- `create(component): ...`
- `add(component): ...`
- `tweak(component): ...`
- `fix(component): ...`

Components: `format`, `regex`, `profile`.
