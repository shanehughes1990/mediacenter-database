# Mediacenter Database

Personal Profilarr Compliant Database (PCD) for building and maintaining custom Sonarr/Radarr configuration.

This repository is the source of truth for:
- custom formats
- regex patterns
- quality profiles
- media management settings

## Goal

Use the `Dictionarry-Hub/profilarr` app with this repo as the linked database, so all profile logic is versioned and reusable across your media stack.

## Repository Layout

- `custom_formats/` → format definitions and conditions
- `regex_patterns/` → reusable regex entities referenced by formats
- `profiles/` → quality profile scoring and upgrade behavior
- `media_management/` → naming, quality definitions, and misc media settings
- `templates/` → starter templates for new entities
- `scripts/` → local helper tooling
- `submodules/database/` → upstream Dictionarry reference database
- `submodules/docs/` → mirrored docs snapshot for local reference

## Workflow

1. Create or tweak regex/custom format/profile YAML.
2. Keep cross-file references valid (`name` values are treated as IDs).
3. Commit changes using the repo convention from `CONTRIBUTING.md`.
4. Sync from Profilarr to Sonarr/Radarr.

## Docs Mirror

Refresh the local docs snapshot:

`./tools/mirror_dictionarry_docs.sh`

Primary output:
- `submodules/docs/dictionarry.dev/`

Logs:
- `submodules/docs/.logs/mirror-run.log`
- `submodules/docs/.logs/wget-main.log`
- `submodules/docs/.logs/wget-sitemap.log`

## Notes

- This is a personal fork/workspace for your own profile strategy.
- Keep compatibility with Profilarr’s PCD expectations when editing schema fields.
