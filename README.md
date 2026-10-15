# Mediacenter Database

Personal Profilarr v2 database for Sonarr and Radarr.

Profilarr v2 reads `pcd.json` and `ops/`. The YAML directories are the v1 definitions kept for reference. v2 cannot load that YAML.

The live policy is:

- `Standard Definition Preferred` is the default. Order is SD, then 720p, then 1080p. Upgrades stop at SD.
- `720p Preferred` is optional. Order is 720p, then 1080p, then SD.
- `1080p Preferred` is optional. Order is 1080p, then 720p, then SD.
- English is preferred by score. Non-English releases are not hard-rejected.
- 4K, BR-DISK, and Raw-HD are disabled.
- Disc-image titles are rejected.

## Repository Layout

- `pcd.json` → v2 database manifest
- `ops/` → append-only SQL that Profilarr v2 compiles
- `custom_formats/`, `regex_patterns/`, `profiles/` → v1 YAML archive
- `media_management/` → naming and size settings not synced by this database
- `submodules/database/` → upstream Dictionarry reference database
- `submodules/docs/` → mirrored docs snapshot for local reference

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
