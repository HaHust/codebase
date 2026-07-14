# CodeGraph query playbook

Use codegraph_explore through MCP with projectPath whenever available. The CLI fallback is:

  /home/ha/.local/bin/codegraph explore -p PROJECT_PATH QUERY

Do not issue one enormous query. Run focused queries and let source evidence determine which follow-up is needed.

## Bootstrap query order

1. Repository and entry points
   - Map application entry points, modules, packages, major responsibilities, internal dependencies, and configuration boundaries. Return current line-numbered source and call relationships.

2. Architecture
   - Trace the main dependency directions and runtime call paths across controllers, handlers, services, domain logic, persistence, integrations, and shared code. Identify boundaries and blast radius.

3. APIs and integrations
   - Inventory inbound routes or protocols, outbound clients, message producers/consumers, validation, authorization, DTOs, handlers, and downstream call paths.

4. Business flows
   - Trace each main user or system flow from trigger through rules, state changes, persistence, events, external calls, results, and failure paths.

5. Business rules
   - Find validations, status or permission checks, boundaries, error behavior, side effects, and related tests. Distinguish implemented rules from names that merely suggest intent.

6. Persistence
   - Map entities/models, repositories/DAOs, queries, transactions, schema/migrations, relationships, and callers. If absent, return evidence supporting NONE_OBSERVED.

7. Conventions and characteristic behaviors
   - Find representative implementations by layer. Compare naming, dependency injection, DTO mapping, error handling, responses, logging, validation, transactions, and tests. Return multiple examples and contradictions.

8. Patterns and reusable components
   - Find structural patterns and shared components with actual callers. Explain reuse conditions, limitations, and blast radius.

9. Test behavior
   - Map test organization, fixture construction, mocking, integration boundaries, assertions, and which production flows have or lack coverage.

## Incremental queries

Start with changed paths and ask:

- What symbols, routes, flows, tests, and callers are affected by these changed, renamed, or deleted files?
- Which architecture boundaries, APIs, database objects, business rules, conventions, reusable components, or characteristic coding behaviors changed?
- Return current source for affected symbols and a blast-radius summary.

Then run only the relevant bootstrap topic queries for the dirty surface.

## Query discipline

- Name a file, route, symbol, feature, or layer when the first result is too broad.
- Use the returned call map and blast radius before using grep.
- Treat CodeGraph line-numbered source as already read.
- Use targeted file reads for pom.xml, Gradle files, package manifests, application configuration, migrations, tests not returned, unsupported file types, or staleness warnings.
- Do not infer an absent behavior from one empty query. Try a precise synonym or inspect the relevant manifest/configuration.
- Record every material query in the run report, but summarize results rather than storing large raw outputs.

## Cross-project integrations

When one project calls another:

- Query each project separately with its own projectPath.
- Record the outbound contract in the caller and the inbound contract in the callee.
- Link the two knowledge records with method/path/protocol and evidence from both projects.
- Do not merge their architectures or behavior catalogs.
