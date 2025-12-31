# Contributing to Remote Inventory View App

Thank you for your interest in contributing! This document provides guidelines for contributing to the project.

## 🚀 Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/YOUR_USERNAME/remote-inventory.git`
3. Run setup: `./setup.sh`
4. Create a branch: `git checkout -b feature/your-feature-name`

## 📝 Development Workflow

### Backend (Go)

```bash
cd backend

# Install dependencies
go mod download

# Generate protobuf code
make proto

# Run tests
make test

# Run locally
make run
```

### Provider App (Flutter)

```bash
cd provider_app

# Get dependencies
flutter pub get

# Run on device/simulator
flutter run

# Run tests
flutter test
```

### Consumer App (Flutter)

```bash
cd consumer_app

# Get dependencies
flutter pub get

# Run on device/simulator
flutter run

# Run tests
flutter test
```

## 🎨 Code Style

### Dart/Flutter
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `flutter format` before committing
- Run `flutter analyze` to check for issues
- Keep widgets focused and reusable
- Use meaningful variable names

### Go
- Follow [Effective Go](https://golang.org/doc/effective_go) guidelines
- Run `go fmt` before committing
- Use `golint` for style checking
- Write clear comments for exported functions
- Keep functions small and focused

### Protobuf
- Use clear, descriptive message names
- Add comments for all fields
- Version your messages appropriately

## 🧪 Testing

### Required Tests
- All new features must include tests
- Maintain or improve code coverage
- Test privacy layer changes extensively
- Verify UI changes on both Android and iOS

### Privacy Testing
**CRITICAL**: Any changes to the privacy layer must be thoroughly tested:
1. Test with various face positions and angles
2. Test with multiple people in frame
3. Test with poor lighting conditions
4. Verify fallback to full-frame blur works
5. Never commit code that could leak faces/bodies

## 📦 Pull Request Process

1. **Update Documentation**: Update README.md if adding features
2. **Add Tests**: Include unit tests for new code
3. **Update CHANGELOG**: Add entry describing changes
4. **Code Review**: Address all review comments
5. **Squash Commits**: Clean up commit history before merging

### PR Title Format
```
[Component] Brief description

Examples:
[Backend] Add WebSocket support for low-latency streaming
[Provider] Improve camera initialization error handling
[Consumer] Add keyboard shortcuts for navigation
[Privacy] Enhance body detection algorithm
[Docs] Update deployment guide for Cloud Run
```

### PR Description Template
```markdown
## What does this PR do?
Brief description of the changes

## Why is this needed?
Explain the problem this solves

## How has this been tested?
- [ ] Unit tests pass
- [ ] Integration tests pass
- [ ] Tested on Android
- [ ] Tested on iOS
- [ ] Privacy layer validated (if applicable)

## Screenshots (if applicable)
Add before/after screenshots for UI changes

## Checklist
- [ ] Code follows style guidelines
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] No breaking changes (or documented)
```

## 🐛 Reporting Bugs

Use the GitHub issue tracker. Include:
- Clear description of the bug
- Steps to reproduce
- Expected vs actual behavior
- Environment (OS, Flutter/Go version, device)
- Screenshots/logs if applicable

## 💡 Feature Requests

- Check existing issues first
- Describe the feature clearly
- Explain the use case
- Consider backwards compatibility

## 🔒 Security

**NEVER** commit:
- API keys or secrets
- Personal data
- Images with identifiable faces
- Production credentials

Report security issues privately to the maintainers.

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

## 🙏 Thank You!

Your contributions help make this project better for everyone!
