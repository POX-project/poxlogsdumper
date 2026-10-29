# AGENTS.md — Rules for AI Agents Working in POX-project/poxlogsdumper

## 1. Semantic Versioning & Release Mandate (Organization-Wide Standard)

All agents working across POX-project repositories must strictly adhere to Semantic Versioning (`MAJOR.MINOR.PATCH`):

1. **PATCH (`x.x.Z` — Last Digit):**
   - Increment for every minor fix, bug resolution, small addition, code hardening, or incremental test/documentation improvement.
2. **MINOR (`x.Y.0` — Middle Digit):**
   - Increment for moderate feature additions, functional enhancements, new controls/screens, or backward-compatible subsystem extensions. Resets PATCH to 0.
3. **MAJOR (`X.0.0` — First Digit):**
   - Increment for major releases, comprehensive rewrites, architectural overhauls, substantial multi-feature milestones, or breaking changes. Resets MINOR and PATCH to 0.

### Release Formatting & Documentation Standard
Every release published across the organization **must** follow a unified, crystal-clear markdown structure to make navigation intuitive and fast for end users:
- **Header Metadata Table / Badges:** Full specification of supported Android versions, kernel targets, SoC/hardware codenames, and recovery environments.
- **Executive Overview:** High-level summary of what this build provides.
- **Detailed Itemized Changelog:** Categorized breakdown (New Features, Improvements, Fixes, Architecture Refactors) derived strictly from the verified commit history.
- **Maintainers & Contributors:** Explicit attribution of authors and maintainers.
- **Cryptographic Verification & Verified Artifacts:** SHA-256 checksums, exact file sizes, and direct links to verified build artifacts (APKs, boot/recovery images, flashable ZIPs, CLI binaries, or build logs).

### Retroactive Compliance for Historical Releases
- If pre-existing or legacy releases are found in any repository, agents must inspect and edit them to bring their release notes and metadata into compliance with the unified standard.
- Old releases must clearly document their supported versions, target devices, changelog, and maintainers so users can seamlessly browse release history.

### Initiating Fresh Builds
- When a new tag is created or code/workflow fixes are implemented, agents must initiate fresh build workflows (via GitHub Actions `workflow_dispatch` or push triggers) and verify that the artifacts are produced, tested, and attached to the release.
- A release is never considered complete until verified artifacts with cryptographic checksums are attached or accounted for.

---

## 2. Deep Commit & Architecture Understanding

- **Inspect Before Touching:** Agents must deeply inspect commit logs (`git log -p`, branch topologies, commit messages, and architectural blueprints) before modifying any code.
- **Log Extraction & Privacy Invariants:** For `poxlogsdumper`, ensure `last_kmsg`, `console-ramoops`, `pstore`, `dmesg`, and recovery log parsing strips any sensitive user identifiers before creating ZIP archives.
- **Build Task Execution & Active Communication:** Agents must relaunch build tasks to verify changes across projects, reporting clearly on every project what is being done.
