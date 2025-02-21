## 0.3.1 - [2025-01-22]

### Added

- Implemented caching system for Dio with TTL (Time-To-Live).
- Supports local file caching using `path_provider`.
- Added shared preferences support for metadata storage.
- Configurable cache folder and expiration time.
- Logging support for debugging.

### Fixed

- Resolved issue with expired cache not being cleared dynamically.
- Improved filename encoding to avoid URL conflicts.

### Changed

- Optimized cache validation to prevent unnecessary redownloads.
- Updated dependencies for better stability.

### TODO

- Improve cache eviction strategy.
- Provide additional storage backends beyond `shared_preferences`.
