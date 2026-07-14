# Codebase Knowledge Builder

This custom Codex agent builds and incrementally refreshes project knowledge with CodeGraph.

## Fixed mapping

- Source projects: immediate non-hidden folders under `$CODEBASE_SOURCE_ROOT`
- Durable knowledge: `$CODEBASE_KNOWLEDGE_ROOT/<project-folder>`
- CodeGraph indexes: <project-folder>/.codegraph
- Agent definition: `~/.codex/agents/codebase-knowledge-builder.toml`

The agent is knowledge-only. It does not edit application source or tests.

## Invoke it

Start a new Codex session after installation, then ask:

  Use codebase_knowledge_builder to scan all projects and build or refresh their durable knowledge.

For one project:

  Use codebase_knowledge_builder to incrementally refresh the order project.

For a forced full scan:

  Use codebase_knowledge_builder to fully rebuild knowledge for customer, including characteristic coding behaviors.

The root session should spawn this custom agent by its exact name and wait for its completion.

## Helper

The deterministic preparation helper supports:

  ~/.codex/agents/codebase-knowledge-builder/prepare-projects.sh list
  ~/.codex/agents/codebase-knowledge-builder/prepare-projects.sh prepare-all
  ~/.codex/agents/codebase-knowledge-builder/prepare-projects.sh prepare order
  ~/.codex/agents/codebase-knowledge-builder/prepare-projects.sh status-all

It discovers projects, initializes or synchronizes CodeGraph, creates the matching knowledge directory, and prints the revision and source fingerprint. The model performs the semantic analysis and writes the knowledge artifacts.

## Main outputs per project

- knowledge-index.md and knowledge-manifest.md
- repository, technology stack, architecture, API, database, business flow, and business rule knowledge
- convention, patterns, and reusable-component catalogs
- coding-behaviors.md for established implementation behavior and future imitation
- incremental-scan.md and timestamped run reports

coding-behaviors.md keeps stable behavior IDs, applicability, examples, variants, exceptions, confidence, verification style, and supersession history. A single example remains a low-confidence candidate.

## Local-only configuration

The agent launches `codegraph serve --mcp`, stores CodeGraph data locally, disables CodeGraph telemetry for its MCP process, and has no network access in its workspace-write sandbox.
