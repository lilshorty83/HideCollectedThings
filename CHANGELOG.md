# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Planned
- Support for hiding collected heirlooms in vendor windows

## [1.2.0] - 2024-09-01
### Added
- Support for hiding collected ensemble sets in vendor windows
- New ensembles.lua file for handling ensemble-specific logic
- Debug command for ensembles (/debugensemble)

### Changed
- Updated main file to integrate ensemble functionality
- Improved consistency across mounts, pets, toys, cosmetics, and ensembles handling

## [1.1.0] - 2024-08-31
### Added
- Support for hiding collected cosmetic items (transmog appearances) in vendor windows
- New cosmetics.lua file for handling cosmetic-specific logic
- Debug commands for mounts (/debugmount), pets (/debugpet), toys (/debugtoy), and cosmetic items (/debugcosmetic)

### Changed
- Updated main file to integrate cosmetic functionality
- Improved consistency across mounts, pets, toys, and cosmetics handling
- Enhanced troubleshooting capabilities with new debug commands

## [1.0.0] - 2024-08-30
### Added
- Initial release of HideCollectedThings
- Functionality to hide collected mounts, pets, and toys in vendor windows
- Slash commands for easy control: `/hct`, `/hct button`, `/hct show`
- Toggle button to show/hide collected items
- Support for the NEW_TOY_ADDED event to update display when new toys are collected
- Compatibility with other addons like CanIMogIt

### Features
- Hides collected mounts, pets, and toys from vendor windows
- Maintains the default UI layout and functionality
- Provides a toggle button for showing/hiding collected items
- Includes slash commands for easy configuration
- Automatically updates when new toys are added to the collection

### Technical Details
- Implements caching for improved performance
- Uses a centralized ShouldHideItem function for consistent item hiding logic
- Hooks into relevant WoW API functions for seamless integration
- Includes separate modules for mounts, pets, and toys handling