# 🌟 mediacenter-database agent guidelines

Hello, and thank you for helping with this repo. The tone can be warm. The rules below stay exact.

## What this place is

This repository is a **Profilarr Compliant Database (PCD)**. `Dictionarry-Hub/profilarr` uses it as the source of truth for Sonarr and Radarr configuration.

Every change keeps **PCD compatibility**, **cross-file name references**, and **predictable sync behavior**. Those three are the whole point.

## What to work on

* Build and maintain the custom formats, regex patterns, quality profiles, and media-management YAML used for Radarr and Sonarr sync.
* Keep each edit small, schema-correct, and in step with the files around it.

## Where things live

* `custom_formats/` holds custom format definitions: conditions, and tests when a format has them.
* `regex_patterns/` holds reusable regex entities that custom format conditions point at.
* `profiles/` holds quality profiles and scoring maps.
* `media_management/` holds naming, quality definitions, and other media settings.
* `templates/` holds pattern templates for new entities.
* `scripts/` holds utility scripts for generation and maintenance.

## Rules to keep close

1. **Treat `name` as the ID.**
   * `name` is the primary identifier across files.
   * Leave a name alone unless a rename was asked for.
   * When a rename is asked for, update every reference in profiles and custom formats.

2. **Keep the YAML shape the neighbors already use.**
   * Match the key order and style of the surrounding files.
   * Add a new schema field only when that field was asked for.

3. **Keep every reference resolvable.**
   * A custom format name in `profiles/*.yml` has a matching file in `custom_formats/`.
   * A regex condition `pattern` name has a matching entity in `regex_patterns/` when it is used as a reusable regex.

4. **Respect how Profilarr syncs.**
   * Profilarr compiles reusable regex and conditions into Arr-native custom formats on sync.
   * One Arr instance syncs from one database. Profile dependencies pull in the custom formats they need.

5. **Write regex for the .NET flavor Profilarr parses with.**
   * Prefer a precise, bounded pattern.
   * A broad or greedy pattern is a last resort.

## How each kind of file likes to look

* `custom_formats/*.yml`
  * Usual fields: `name`, `description`, `tags`, `conditions`, `tests`.
  * Each condition has a coherent `type`, `required`, and `negate`.

* `regex_patterns/*.yml`
  * Keep `name`, `pattern`, `tags`, and the optional `description` accurate, and reusable by more than one format.

* `profiles/*.yml`
  * Make every score intentional and easy to read.
  * Keep the sections a file already has, such as `custom_formats`, `custom_formats_radarr`, `custom_formats_sonarr`, `qualities`, and `upgrade_until`.

* `media_management/*.yml`
  * Spell out the Radarr and Sonarr structures. Leave implicit defaults out.

## How to make a change

* Read the related files first, then make the smallest edit that does the job.
* After the edit, check that names still resolve: profile to custom format, and condition to regex.
* Save broad refactors, file moves, and mass reformatting for the day someone asks for them.
* When a request is ambiguous, pick the simplest reading that still matches the schema.

## Commit messages this repo likes

* `create(component): ...`
* `add(component): ...`
* `tweak(component): ...`
* `fix(component): ...`

Components: `format`, `regex`, `profile`.
