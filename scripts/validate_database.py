#!/usr/bin/env python3
import sys
from pathlib import Path

import yaml


ROOT = Path(__file__).resolve().parents[1]
CUSTOM_FORMATS = ROOT / "custom_formats"
REGEX_PATTERNS = ROOT / "regex_patterns"
PROFILES = ROOT / "profiles"
MEDIA_MANAGEMENT = ROOT / "media_management"


def load_yaml_file(path: Path):
    with path.open("r", encoding="utf-8") as file:
        return yaml.safe_load(file) or {}


def collect_yml_files(path: Path):
    if not path.exists():
        return []
    return sorted([file for file in path.glob("*.yml") if file.name != ".gitkeep"])


def main():
    errors = []

    # Parse all YAML first
    parsed = {}
    for section in [CUSTOM_FORMATS, REGEX_PATTERNS, PROFILES, MEDIA_MANAGEMENT]:
        for file in collect_yml_files(section):
            try:
                parsed[file] = load_yaml_file(file)
            except Exception as exc:
                errors.append(f"YAML parse error in {file.relative_to(ROOT)}: {exc}")

    if errors:
        print("VALIDATION FAILED")
        for err in errors:
            print(f"- {err}")
        return 1

    regex_names = {
        data.get("name")
        for file, data in parsed.items()
        if file.parent == REGEX_PATTERNS and data.get("name")
    }

    custom_format_names = {
        data.get("name")
        for file, data in parsed.items()
        if file.parent == CUSTOM_FORMATS and data.get("name")
    }

    # Custom format checks
    for file, data in parsed.items():
        if file.parent != CUSTOM_FORMATS:
            continue

        conditions = data.get("conditions") or []
        if not conditions:
            errors.append(f"{file.relative_to(ROOT)} has no conditions")
            continue

        for condition in conditions:
            condition_type = condition.get("type")
            if condition_type in {"release_title", "release_group", "edition"}:
                pattern_ref = condition.get("pattern")
                if not pattern_ref:
                    errors.append(
                        f"{file.relative_to(ROOT)} condition '{condition.get('name', '<unnamed>')}' missing pattern reference"
                    )
                elif pattern_ref not in regex_names:
                    errors.append(
                        f"{file.relative_to(ROOT)} condition '{condition.get('name', '<unnamed>')}' references missing regex pattern '{pattern_ref}'"
                    )

        tests = data.get("tests")
        if tests is not None and not isinstance(tests, list):
            errors.append(f"{file.relative_to(ROOT)} tests must be a list")

    # Profile checks
    for file, data in parsed.items():
        if file.parent != PROFILES:
            continue

        for key in ["custom_formats", "custom_formats_radarr", "custom_formats_sonarr"]:
            refs = data.get(key, []) or []
            if not isinstance(refs, list):
                errors.append(f"{file.relative_to(ROOT)} field '{key}' must be a list")
                continue

            for entry in refs:
                name = entry.get("name") if isinstance(entry, dict) else None
                if not name:
                    errors.append(f"{file.relative_to(ROOT)} field '{key}' has invalid format entry")
                    continue
                if name not in custom_format_names:
                    errors.append(
                        f"{file.relative_to(ROOT)} field '{key}' references missing custom format '{name}'"
                    )

    # Media management checks
    for file, data in parsed.items():
        if file.parent != MEDIA_MANAGEMENT:
            continue
        if not isinstance(data, dict) or not data:
            errors.append(f"{file.relative_to(ROOT)} must contain a YAML object")

    if errors:
        print("VALIDATION FAILED")
        for err in errors:
            print(f"- {err}")
        return 1

    print("VALIDATION PASSED")
    print(f"- Regex patterns: {len(regex_names)}")
    print(f"- Custom formats: {len(custom_format_names)}")
    print(f"- Profiles: {len(collect_yml_files(PROFILES))}")
    print(f"- Media management files: {len(collect_yml_files(MEDIA_MANAGEMENT))}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
