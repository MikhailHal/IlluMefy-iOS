# Frequently Used Commands

## Build & Test
```bash
# Build project
xcodebuild -project IlluMefy/IlluMefy.xcodeproj -scheme IlluMefy -configuration Debug build

# Run tests
xcodebuild test -project IlluMefy/IlluMefy.xcodeproj -scheme IlluMefy -destination 'platform=iOS Simulator,name=iPhone 15'

# Clean build
xcodebuild clean -project IlluMefy/IlluMefy.xcodeproj -scheme IlluMefy
```

## SwiftGen
```bash
cd IlluMefy/IlluMefy && swiftgen run strings Resources/Localizable.strings -t structured-swift5 -o Generated/Strings.swift
```

## Git Workflow
```bash
# Check changes
git status
git diff

# Commit and push
git add -A
git commit -m "feat: description"
git push origin main
```

## Swift Format (if installed)
```bash
swift-format -i -r IlluMefy/
```

## Find TODOs
```bash
rg "TODO|FIXME|HACK" --type swift
```