# CLAUDE.md - NeuroVis Project Instructions

## Project Overview
**NeuroVis** is an advanced educational neuroscience visualization platform built with Godot 4.4.1 for interactive brain anatomy exploration. It's designed for medical students, neuroscience researchers, and healthcare professionals as a comprehensive learning tool for neuroanatomy education.

## Current Task Context
You are currently working on enhancing the Gemini AI integration for the educational platform. The feature branch is focused on implementing Google's Gemini API for enhanced educational AI assistance within the application.

## Project Structure
The project follows a modern, educational-focused modular architecture:

- `core/` - Business logic & core systems
  - `ai/` - AI services for educational support (current focus)
  - `interaction/` - User interaction handling
  - `knowledge/` - Educational content management
  - `models/` - 3D model management
  - `systems/` - Core educational systems

- `ui/` - Educational user interface
  - `components/` - Reusable educational UI components
  - `panels/` - Educational information panels
  - `theme/` - Educational design system

- `scenes/` - Godot scenes for educational workflows
- `assets/` - Educational content assets
- `docs/` - Educational platform documentation

## Current AI Integration

The Gemini integration is currently in progress:
- `core/ai/GeminiAIService.gd` - Main service for Gemini API communication
- `core/ai/AIAssistantService.gd` - General AI assistant interface
- `ui/components/panels/AIAssistantPanel.gd` - UI for AI interactions

## Development Standards
- Follow GDScript coding standards with proper documentation
- Use proper error handling and educational context
- Maintain separation between UI and business logic
- Keep educational terminology accurate and consistent
- Ensure accessibility compliance

## Key Commands
- `claude config show` - Show current Claude configuration
- `claude --config ./.claude/config.json` - Use project-specific configuration
- `claude -p "Your prompt"` - Send quick prompt to Claude

## GitHub Workflow
- Current branch: `feature/gemini-integration`
- Make atomic commits with clear messages
- Use standard commit format: `<type>(<scope>): <description>`
