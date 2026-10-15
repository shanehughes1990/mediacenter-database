-- Mediacenter quality policy.
-- Standard Definition Preferred is the default: SD, then 720p, then 1080p.
-- 720p Preferred and 1080p Preferred are optional and are not the default.
-- English is a score preference. 4K, BR-DISK, and Raw-HD stay disabled.
-- Disc-image titles are rejected.

INSERT INTO tags (name) VALUES
('SD'),
('Standard Definition'),
('Backwards Upgrade'),
('720p'),
('1080p'),
('Disc'),
('Rejection'),
('Language'),
('Safety');

INSERT INTO regular_expressions (name, pattern, description) VALUES
('Disc Image', '(?i)\b(DVD9|DVD5|BD25|BD50|BD100)\b|\bISO\b', 'Matches disc-image release titles, including ISO and named DVD or Blu-ray disc sizes.'),
('Foreign Language Tag Pattern', '(?i)\b(german|french|italian|spanish|latino|russian|polish|turkish|japanese|korean|hindi|tamil|telugu|vostfr|ita|ger|rus)\b', 'Matches common foreign-language indicators in release titles.'),
('Dual Audio', '\b((multi[^a-zA-Z]*)|(dual[\s.-](audio|complete)))\b', 'Matches releases with dual-audio or multi-language indicators in the title.');

INSERT INTO regular_expression_tags (regular_expression_name, tag_name) VALUES
('Disc Image', 'Disc'),
('Disc Image', 'Rejection'),
('Foreign Language Tag Pattern', 'Language'),
('Foreign Language Tag Pattern', 'Safety');

INSERT INTO custom_formats (name, description) VALUES
('Disc Image', 'Rejects releases whose title is a disc image or a named DVD or Blu-ray disc size.'),
('Not English', 'Matches releases that do not include an English language track. Dual audio is allowed.'),
('Not Only English', 'Matches releases that do not include an English language track. Dual audio is not allowed.'),
('Not Only English (Missing)', 'Matches releases with multiple audio tracks that were not parsed as multi-language, using dual-audio title markers.'),
('Foreign Language Title Tags', 'Penalizes releases with common foreign-language title tags. This is a preference, not a hard reject.');

INSERT INTO custom_format_tags (custom_format_name, tag_name) VALUES
('Disc Image', 'Disc'),
('Disc Image', 'Rejection'),
('Not English', 'Language'),
('Not Only English', 'Language'),
('Not Only English (Missing)', 'Language'),
('Foreign Language Title Tags', 'Language'),
('Foreign Language Title Tags', 'Safety');

INSERT INTO custom_format_conditions (custom_format_name, name, type, arr_type, negate, required) VALUES
('Disc Image', 'Disc Image', 'release_title', 'all', 0, 1),
('Not English', 'Not English', 'language', 'all', 0, 1),
('Not English', 'Includes English', 'language', 'all', 1, 1),
('Not Only English', 'Not English', 'language', 'all', 0, 1),
('Not Only English', 'Includes English', 'language', 'all', 0, 1),
('Not Only English (Missing)', 'Includes English', 'language', 'all', 0, 1),
('Not Only English (Missing)', 'Dual Audio Regex', 'release_title', 'all', 0, 1),
('Foreign Language Title Tags', 'Foreign Language Tag Pattern', 'release_title', 'all', 0, 1);

INSERT INTO condition_patterns (custom_format_name, condition_name, regular_expression_name) VALUES
('Disc Image', 'Disc Image', 'Disc Image'),
('Not Only English (Missing)', 'Dual Audio Regex', 'Dual Audio'),
('Foreign Language Title Tags', 'Foreign Language Tag Pattern', 'Foreign Language Tag Pattern');

INSERT INTO condition_languages (custom_format_name, condition_name, language_name, except_language) VALUES
('Not English', 'Not English', 'English', 1),
('Not English', 'Includes English', 'English', 0),
('Not Only English', 'Not English', 'English', 1),
('Not Only English', 'Includes English', 'English', 0),
('Not Only English (Missing)', 'Includes English', 'English', 0);

INSERT INTO custom_format_tests (custom_format_name, title, type, should_match) VALUES
('Disc Image', 'Sailor.Moon.S01E01-E08.NTSC.USA.DVD9-AndreMor', 'series', 1),
('Disc Image', 'Show.Name.S01E01.480p.WEB.x264', 'series', 0),
('Disc Image', 'Movie.Name.2001.BD50.ISO', 'movie', 1),
('Foreign Language Title Tags', 'Leroy.2006.German.DVDRip.XVID', 'movie', 1),
('Foreign Language Title Tags', 'Anime.Movie.2024.VOSTFR.1080p.WEB-DL', 'movie', 1),
('Foreign Language Title Tags', 'Classic.Movie.1999.English.480p.DVD', 'movie', 0),
('Not Only English (Missing)', 'Attack.on.Titan.S04.1080p.BluRay.Dual-Audio.DTS-HD', 'series', 1),
('Not Only English (Missing)', 'Example.Movie.2001.English.1080p.WEB-DL', 'movie', 0);

INSERT INTO quality_profiles (name, description, upgrades_allowed, minimum_custom_format_score, upgrade_until_score, upgrade_score_increment) VALUES
('Standard Definition Preferred', 'SD-first profile. English is preferred. 720p and 1080p are used only when no SD release exists. 4K is not allowed. Disc images are rejected.', 1, -10000, 0, 1),
('720p Preferred', '720p-first profile. English is preferred. 1080p is used when no 720p release exists, and SD only after that. 4K is not allowed. Disc images are rejected. This is not the default profile.', 1, -10000, 0, 1),
('1080p Preferred', '1080p-first profile. English is preferred. 720p is used when no 1080p release exists, and SD only after that. 4K is not allowed. Disc images are rejected. This is not the default profile.', 1, -10000, 0, 1);

INSERT INTO quality_profile_tags (quality_profile_name, tag_name) VALUES
('Standard Definition Preferred', 'SD'),
('Standard Definition Preferred', 'Standard Definition'),
('Standard Definition Preferred', 'Backwards Upgrade'),
('720p Preferred', '720p'),
('720p Preferred', 'Backwards Upgrade'),
('1080p Preferred', '1080p'),
('1080p Preferred', 'Backwards Upgrade');

INSERT INTO quality_profile_languages (quality_profile_name, language_name, type) VALUES
('Standard Definition Preferred', 'Any', 'must'),
('720p Preferred', 'Any', 'must'),
('1080p Preferred', 'Any', 'must');

INSERT INTO quality_groups (quality_profile_name, name) VALUES
('Standard Definition Preferred', 'SD Lowest First'),
('Standard Definition Preferred', '720p Fallback'),
('Standard Definition Preferred', '1080p Last Resort'),
('Standard Definition Preferred', 'Radarr Source-Specific (Lowest Priority)'),
('720p Preferred', '720p Preferred'),
('720p Preferred', '1080p Fallback'),
('720p Preferred', 'SD Last Resort'),
('720p Preferred', 'Radarr Source-Specific (Lowest Priority)'),
('1080p Preferred', '1080p Preferred'),
('1080p Preferred', '720p Fallback'),
('1080p Preferred', 'SD Last Resort'),
('1080p Preferred', 'Radarr Source-Specific (Lowest Priority)');

INSERT INTO quality_group_members (quality_profile_name, quality_group_name, quality_name, position) VALUES
('Standard Definition Preferred', 'SD Lowest First', 'SDTV', 0),
('Standard Definition Preferred', 'SD Lowest First', 'DVD', 1),
('Standard Definition Preferred', 'SD Lowest First', 'WEBDL-480p', 2),
('Standard Definition Preferred', 'SD Lowest First', 'WEBRip-480p', 3),
('Standard Definition Preferred', 'SD Lowest First', 'Bluray-480p', 4),
('Standard Definition Preferred', 'SD Lowest First', 'Bluray-576p', 5),
('Standard Definition Preferred', '720p Fallback', 'HDTV-720p', 0),
('Standard Definition Preferred', '720p Fallback', 'WEBRip-720p', 1),
('Standard Definition Preferred', '720p Fallback', 'WEBDL-720p', 2),
('Standard Definition Preferred', '720p Fallback', 'Bluray-720p', 3),
('Standard Definition Preferred', '1080p Last Resort', 'HDTV-1080p', 0),
('Standard Definition Preferred', '1080p Last Resort', 'WEBRip-1080p', 1),
('Standard Definition Preferred', '1080p Last Resort', 'WEBDL-1080p', 2),
('Standard Definition Preferred', '1080p Last Resort', 'Bluray-1080p', 3),
('Standard Definition Preferred', '1080p Last Resort', 'Remux-1080p', 4),
('Standard Definition Preferred', 'Radarr Source-Specific (Lowest Priority)', 'WORKPRINT', 0),
('Standard Definition Preferred', 'Radarr Source-Specific (Lowest Priority)', 'CAM', 1),
('Standard Definition Preferred', 'Radarr Source-Specific (Lowest Priority)', 'TELESYNC', 2),
('Standard Definition Preferred', 'Radarr Source-Specific (Lowest Priority)', 'TELECINE', 3),
('Standard Definition Preferred', 'Radarr Source-Specific (Lowest Priority)', 'DVDSCR', 4),
('Standard Definition Preferred', 'Radarr Source-Specific (Lowest Priority)', 'REGIONAL', 5),
('Standard Definition Preferred', 'Radarr Source-Specific (Lowest Priority)', 'DVD-R', 6),
('720p Preferred', '720p Preferred', 'HDTV-720p', 0),
('720p Preferred', '720p Preferred', 'WEBRip-720p', 1),
('720p Preferred', '720p Preferred', 'WEBDL-720p', 2),
('720p Preferred', '720p Preferred', 'Bluray-720p', 3),
('720p Preferred', '1080p Fallback', 'HDTV-1080p', 0),
('720p Preferred', '1080p Fallback', 'WEBRip-1080p', 1),
('720p Preferred', '1080p Fallback', 'WEBDL-1080p', 2),
('720p Preferred', '1080p Fallback', 'Bluray-1080p', 3),
('720p Preferred', '1080p Fallback', 'Remux-1080p', 4),
('720p Preferred', 'SD Last Resort', 'SDTV', 0),
('720p Preferred', 'SD Last Resort', 'DVD', 1),
('720p Preferred', 'SD Last Resort', 'WEBDL-480p', 2),
('720p Preferred', 'SD Last Resort', 'WEBRip-480p', 3),
('720p Preferred', 'SD Last Resort', 'Bluray-480p', 4),
('720p Preferred', 'SD Last Resort', 'Bluray-576p', 5),
('720p Preferred', 'Radarr Source-Specific (Lowest Priority)', 'WORKPRINT', 0),
('720p Preferred', 'Radarr Source-Specific (Lowest Priority)', 'CAM', 1),
('720p Preferred', 'Radarr Source-Specific (Lowest Priority)', 'TELESYNC', 2),
('720p Preferred', 'Radarr Source-Specific (Lowest Priority)', 'TELECINE', 3),
('720p Preferred', 'Radarr Source-Specific (Lowest Priority)', 'DVDSCR', 4),
('720p Preferred', 'Radarr Source-Specific (Lowest Priority)', 'REGIONAL', 5),
('720p Preferred', 'Radarr Source-Specific (Lowest Priority)', 'DVD-R', 6),
('1080p Preferred', '1080p Preferred', 'HDTV-1080p', 0),
('1080p Preferred', '1080p Preferred', 'WEBRip-1080p', 1),
('1080p Preferred', '1080p Preferred', 'WEBDL-1080p', 2),
('1080p Preferred', '1080p Preferred', 'Bluray-1080p', 3),
('1080p Preferred', '1080p Preferred', 'Remux-1080p', 4),
('1080p Preferred', '720p Fallback', 'HDTV-720p', 0),
('1080p Preferred', '720p Fallback', 'WEBRip-720p', 1),
('1080p Preferred', '720p Fallback', 'WEBDL-720p', 2),
('1080p Preferred', '720p Fallback', 'Bluray-720p', 3),
('1080p Preferred', 'SD Last Resort', 'SDTV', 0),
('1080p Preferred', 'SD Last Resort', 'DVD', 1),
('1080p Preferred', 'SD Last Resort', 'WEBDL-480p', 2),
('1080p Preferred', 'SD Last Resort', 'WEBRip-480p', 3),
('1080p Preferred', 'SD Last Resort', 'Bluray-480p', 4),
('1080p Preferred', 'SD Last Resort', 'Bluray-576p', 5),
('1080p Preferred', 'Radarr Source-Specific (Lowest Priority)', 'WORKPRINT', 0),
('1080p Preferred', 'Radarr Source-Specific (Lowest Priority)', 'CAM', 1),
('1080p Preferred', 'Radarr Source-Specific (Lowest Priority)', 'TELESYNC', 2),
('1080p Preferred', 'Radarr Source-Specific (Lowest Priority)', 'TELECINE', 3),
('1080p Preferred', 'Radarr Source-Specific (Lowest Priority)', 'DVDSCR', 4),
('1080p Preferred', 'Radarr Source-Specific (Lowest Priority)', 'REGIONAL', 5),
('1080p Preferred', 'Radarr Source-Specific (Lowest Priority)', 'DVD-R', 6);

-- Position 0 is the preferred tier and the upgrade cutoff.
INSERT INTO quality_profile_qualities (quality_profile_name, quality_group_name, position, enabled, upgrade_until) VALUES
('Standard Definition Preferred', 'SD Lowest First', 0, 1, 1),
('Standard Definition Preferred', '720p Fallback', 1, 1, 0),
('Standard Definition Preferred', '1080p Last Resort', 2, 1, 0),
('Standard Definition Preferred', 'Radarr Source-Specific (Lowest Priority)', 3, 1, 0),
('720p Preferred', '720p Preferred', 0, 1, 1),
('720p Preferred', '1080p Fallback', 1, 1, 0),
('720p Preferred', 'SD Last Resort', 2, 1, 0),
('720p Preferred', 'Radarr Source-Specific (Lowest Priority)', 3, 1, 0),
('1080p Preferred', '1080p Preferred', 0, 1, 1),
('1080p Preferred', '720p Fallback', 1, 1, 0),
('1080p Preferred', 'SD Last Resort', 2, 1, 0),
('1080p Preferred', 'Radarr Source-Specific (Lowest Priority)', 3, 1, 0);

INSERT INTO quality_profile_qualities (quality_profile_name, quality_name, position, enabled, upgrade_until)
SELECT profile.name, quality.name, 4 + quality.position, 0, 0
FROM (
    SELECT 'Standard Definition Preferred' AS name
    UNION ALL SELECT '720p Preferred'
    UNION ALL SELECT '1080p Preferred'
) AS profile
JOIN (
    SELECT 0 AS position, 'Unknown' AS name
    UNION ALL SELECT 1, 'HDTV-480p'
    UNION ALL SELECT 2, 'HDTV-2160p'
    UNION ALL SELECT 3, 'WEBDL-2160p'
    UNION ALL SELECT 4, 'WEBRip-2160p'
    UNION ALL SELECT 5, 'Bluray-2160p'
    UNION ALL SELECT 6, 'Remux-2160p'
    UNION ALL SELECT 7, 'BR-DISK'
    UNION ALL SELECT 8, 'Raw-HD'
) AS quality;

INSERT INTO quality_profile_custom_formats (quality_profile_name, custom_format_name, arr_type, score)
SELECT profile.name, format.name, 'all', format.score
FROM (
    SELECT 'Standard Definition Preferred' AS name
    UNION ALL SELECT '720p Preferred'
    UNION ALL SELECT '1080p Preferred'
) AS profile
JOIN (
    SELECT 'Disc Image' AS name, -100000 AS score
    UNION ALL SELECT 'Not English', -8000
    UNION ALL SELECT 'Not Only English', 0
    UNION ALL SELECT 'Not Only English (Missing)', 0
    UNION ALL SELECT 'Foreign Language Title Tags', -1500
) AS format;
