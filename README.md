# 🎬 Mediacenter Database

This is a personal Profilarr v2 database for Sonarr and Radarr, tuned with a lot of care and a clear favorite: a nice, modest release that plays without a fuss.

Profilarr v2 reads `pcd.json` and `ops/`. The YAML directories are the v1 definitions, kept nearby for reference. v2 loads the PCD and the SQL. It leaves that YAML on the shelf.

## The live policy, said with a smile

* `Standard Definition Preferred` is the default. The order is SD, then 720p, then 1080p. Upgrades stop once an SD release is home.
* `720p Preferred` is there when you want it. The order is 720p, then 1080p, then SD.
* `1080p Preferred` is there when you want it. The order is 1080p, then 720p, then SD.
* English gets a higher score. Other languages stay welcome. Nothing is hard-rejected for language.
* 4K, BR-DISK, and Raw-HD are turned off.
* Disc-image titles are rejected. The library likes files it can press play on.

## How the folders are laid out

* `pcd.json` is the v2 database manifest.
* `ops/` holds the append-only SQL that Profilarr v2 compiles.
* `custom_formats/`, `regex_patterns/`, and `profiles/` are the v1 YAML archive.
* `media_management/` holds naming and size settings that this database does not sync.
* `submodules/database/` is the upstream Dictionarry reference database.
* `submodules/docs/` is a mirrored docs snapshot for reading offline.

## Refreshing the docs mirror

Bring the local docs snapshot up to date with:

`./tools/mirror_dictionarry_docs.sh`

The pages land in:

* `submodules/docs/dictionarry.dev/`

The logs land in:

* `submodules/docs/.logs/mirror-run.log`
* `submodules/docs/.logs/wget-main.log`
* `submodules/docs/.logs/wget-sitemap.log`

## A few kind reminders

* This repo is a personal fork for one profile strategy. Make it yours.
* When a schema field changes, keep it compatible with what Profilarr expects from a PCD.
