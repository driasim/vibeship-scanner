-- Add scanners column to track individual scanner progress
-- This enables real-time UI updates showing which scanners have completed

ALTER TABLE scan_progress
ADD COLUMN IF NOT EXISTS scanners JSONB DEFAULT NULL;

-- The scanners column stores an array of scanner status objects:
-- [
--   {
--     "name": "opengrep",
--     "category": "universal",
--     "targets": "SAST patterns across all languages",
--     "trigger": "always",
--     "status": "complete",  -- pending, running, complete, error
--     "findings": 127,
--     "duration_ms": 5420
--   },
--   ...
-- ]

COMMENT ON COLUMN scan_progress.scanners IS 'JSON array of individual scanner statuses for real-time progress display';
