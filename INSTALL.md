# Installation Guide

`Libgnss_Coding` is distributed as a standard Swift Package. It is a pure Swift library with no external dependencies, making it highly portable and easy to integrate into any project.

## Requirements

*   **Swift:** Version 6.0 or later.
*   **Platforms:** macOS, iOS, tvOS, watchOS, visionOS, Linux, and Windows.

## Adding via Swift Package Manager (SPM)

### Option 1: Xcode
1. Open your project in Xcode.
2. Go to **File > Add Package Dependencies...**
3. Enter the repository URL. *(e.g., `https://github.com/your-org/libgnss-coding-swift.git`)*.
4. Select your preferred version rule (e.g., "Up to Next Major") and click **Add Package**.
5. Ensure the `Libgnss_Coding` library is added to your target.

### Option 2: `Package.swift`
If you are developing another Swift Package or a command-line executable, add the dependency to your `Package.swift` file:

```swift
// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "YourProject",
    dependencies: [
        // Add the package dependency
        .package(url: "https://github.com/your-org/libgnss-coding-swift.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "YourTarget",
            dependencies: [
                // Link the library to your target
                .product(name: "Libgnss_Coding", package: "libgnss-coding-swift")
            ]
        )
    ]
)
```
*(Note: Replace the repository URL with the actual git remote URL once published.)*

## Building from Source

If you want to build, test, or contribute to the library locally:

```bash
# Clone the repository
git clone https://github.com/your-org/libgnss-coding-swift.git
cd libgnss-coding-swift

# Build the library
swift build

# Run the test suite
swift test
```
