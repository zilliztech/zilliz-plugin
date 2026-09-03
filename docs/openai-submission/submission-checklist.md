# Submission checklist

## Repository and package

- [ ] `.codex-plugin/plugin.json` contains the intended version and public metadata.
- [ ] Every runtime skill has a valid `skills/<name>/SKILL.md`.
- [ ] Skills contain no platform-specific runtime instructions or undeclared dependencies.
- [ ] Destructive actions require exact targets and explicit confirmation.
- [ ] Credentials are never requested in the conversation.
- [ ] `python3 scripts/validate_openai_plugin.py` passes.
- [ ] `scripts/package_openai_plugin.sh` produces the expected ZIP and checksum.
- [ ] The ZIP contains only `zilliz/.codex-plugin/`, `zilliz/skills/`, and `zilliz/assets/`.
- [ ] The ZIP was tested in a clean environment.

## Portal listing

- [ ] Zilliz business identity is verified in the submitting OpenAI organization.
- [ ] The submitter has Apps Management write access.
- [ ] Name, descriptions, category, logo, website, and support URL are final.
- [ ] Privacy policy and Terms of Service URLs are confirmed by the responsible teams.
- [ ] Starter prompts are copied from `starter-prompts.md` and reviewed.
- [ ] Five positive and three negative test cases are copied from `test-cases.md` and reviewed.
- [ ] Country and region availability is approved.
- [ ] Release notes describe the initial submission or update.
- [ ] Required policy attestations are complete.

## Sensitive review information

- [ ] Reviewer credentials are entered directly in the portal and are not committed to Git.
- [ ] The reviewer account does not require MFA, email confirmation, SMS confirmation, or private-network access.
- [ ] Fixture data covers every submitted positive test case.
- [ ] No production credentials, identifiers, or customer data are used.
- [ ] The OpenAI partner has confirmed the supported local CLI execution and authentication flow.
