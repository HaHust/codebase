# Durable project knowledge schema

Each source folder named PROJECT maps to exactly:

  ~/.codex/projects/PROJECT/

All paths inside knowledge files are relative to the source project unless an absolute path is required to identify another project.

## Required files

1. knowledge-index.md
   - Project identity and one-paragraph summary.
   - Recommended read order.
   - Task-to-knowledge routing table.
   - Artifact summaries, freshness, confidence, and gaps.
   - Future-development checklist.

2. knowledge-manifest.md
   - Schema version.
   - Source path and knowledge path.
   - Scan mode and status: BUILDING, READY_FOR_USE, PARTIAL, or BLOCKED.
   - Scan timestamp with timezone.
   - Enclosing Git root, HEAD revision, dirty paths, and source fingerprint.
   - CodeGraph version, index status, indexed file/node/edge counts when available.
   - Previous baseline and changed/renamed/deleted paths for incremental runs.
   - Artifact table with status, confidence, owner, and last update.
   - Validation checklist, conflicts, gaps, and failure codes.

3. repository.md
   - Modules, packages, entry points, dependency/build structure, commands supported by evidence, configuration, deployment/CI surfaces, and risks.

4. technology-stack.md
   - Runtime, language, framework, build/test tools, dependencies, infrastructure, declared-versus-used checks, versions, purposes, and confidence.
   - Include a compact skill matrix in this file.

5. architecture.md
   - Evidence-backed architecture classification, text diagram, boundaries, dependency direction, cross-cutting concerns, integrations, violations, and risks.

6. api-index.md
   - Inbound, outbound, and messaging contracts.
   - Method/protocol, path/topic, owner, request, response, validation, authorization, downstream mapping, compatibility notes, and evidence.

7. database.md
   - Models/entities, tables, relations, repositories, queries, indexes, migrations, transaction behavior, evidence, and risks.
   - Explicitly state NONE_OBSERVED when no persistence layer exists.

8. business-flow.md
   - Actor/trigger, ordered call path, state transitions, validation, side effects, integrations, failure/rollback behavior, tests, evidence, and open questions.

9. business-rule.md
   - Stable rule ID, trigger, enforcement, boundary/permission, error/result behavior, tests, evidence, confidence, and conflicts.

10. convention.md
    - Naming, packages, annotations, comments, logging, errors, validation, response, DTO, mapping, service, repository, transaction, and test conventions.
    - Separate DOMINANT, ACCEPTED_VARIANT, CANDIDATE, and OBSERVED_RISK.

11. patterns.md
    - Design and codebase-specific patterns, intent, collaborators, reuse conditions, non-use conditions, limitations, evidence, and risks.

12. component-index.md
    - Reusable component, location, purpose, public usage shape, callers, owner if evidenced, limitations, compatibility risk, and evidence.

13. coding-behaviors.md
    - Durable behavioral catalog defined below.

14. decision.md
    - Only accepted and evidenced decisions.
    - Context, rationale, accepted option, rejected alternatives, consequences, reversibility, approval evidence, status, and supersession links.
    - Use NONE_OBSERVED if no accepted decision artifact exists.

15. incremental-scan.md
    - Baseline/current state, changed path classification, CodeGraph blast radius, dirty artifact mapping, refresh actions, and full-scan escalation reason if any.
    - On a full scan, record that this file establishes the initial baseline.

16. runs/YYYYMMDDTHHMMSSZ.md
    - Agent name, mode, project, references read, CodeGraph commands/queries, files inspected, knowledge files changed, validation result, assumptions, conflicts, gaps, and failure codes.

## Coding behavior record

Use stable IDs such as CB-API-001, CB-SERVICE-001, CB-DATA-001, CB-TEST-001, or CB-CROSS-001.

Each record contains:

- ID and concise name.
- Status: CANDIDATE, ACTIVE, OBSERVED_RISK, or SUPERSEDED.
- Scope: project/module/layer.
- Trigger: when this behavior applies.
- Canonical sequence: ordered implementation behavior.
- Representative evidence: normally two or more source/test citations.
- Accepted variants and selection conditions.
- Exceptions or contradictions.
- Future guidance: what a new implementation should imitate.
- Non-use guidance: when not to copy it.
- Test/verification behavior to mirror.
- Confidence: HIGH, MEDIUM, or LOW with a reason.
- First seen, last seen, and superseded by.

Promotion rules:

- One example remains CANDIDATE and LOW confidence.
- Two consistent examples may become ACTIVE and MEDIUM confidence.
- Multiple examples across relevant modules plus tests may become ACTIVE and HIGH confidence.
- Repetition alone does not make behavior desirable. Suspected defects become OBSERVED_RISK.
- Conflicting examples remain scoped variants or unresolved contradictions.

## Evidence format

Use project-relative citations:

  src/main/java/example/Foo.java:L12-L31

For a claim derived from a build descriptor or test, cite it exactly the same way.
For cross-project behavior, prefix the other project name and give its absolute source project path once.
Do not store raw secret values.

## Fingerprint

Prefer a deterministic SHA-256 over sorted source file paths and content, excluding .git, .codegraph, build outputs, caches, dependency directories, and the knowledge output.
Record the algorithm identifier so future incremental scans use the same method.

## Write order

Write topic artifacts first, coding-behaviors.md next, knowledge-index.md after every topic is stable, knowledge-manifest.md next, and the run report last.
