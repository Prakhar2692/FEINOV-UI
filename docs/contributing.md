# Contribution conventions

## Branching

Use a simple, predictable branch model:

- `feature/<short-name>` for new features
- `fix/<short-name>` for bug fixes
- `chore/<short-name>` for tooling and cleanup
- `docs/<short-name>` for documentation work

## Commit conventions

Use concise, descriptive commit messages:

```bash
git commit -m "feat(auth): add login and OTP verification flow"
git commit -m "fix(search): correct loading state on empty query"
git commit -m "docs: add environment and setup documentation"
```

## Code style

- Follow Dart and Flutter conventions.
- Prefer small, reusable widgets over heavily nested widget trees.
- Keep feature logic in feature folders and shared rules in `lib/core`.
- Use typed models and avoid `dynamic` where possible.

## Pull request checklist

Before opening a pull request:

- `flutter pub get`
- `flutter pub run build_runner build --delete-conflicting-outputs`
- `flutter analyze`
- `flutter test`
- Confirm docs are updated if behavior or setup changes

## Review expectations

- Keep PRs focused on a single concern.
- Include screenshots or screen recordings for UI changes.
- Note any backend contract assumptions.
- Update the backlog or roadmap if scope changes.
