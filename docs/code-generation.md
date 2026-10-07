# Code generation guide

This project uses code generation for Riverpod, Freezed, and JSON serialization. Generated files should be treated as build artifacts, not hand-edited sources.

## Generate code

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Watch mode

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

## When to regenerate

Run code generation when you:

- add or modify a Freezed model
- add new JSON serializable classes
- change Riverpod providers or controllers
- update generated router or DI code

## Best practices

- Prefer running generation after each meaningful model update.
- Do not manually edit generated files under `*.g.dart`.
- If a generated file is stale, rebuild rather than patching it by hand.
- Commit generated files only when they are part of the intentional app source and the project requires them.
