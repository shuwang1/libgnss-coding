# libgnss-coding-swift (Libgnss_Coding)

Swift implementation of GNSS-related coding and parity check algorithms, based on the `libgnss-coding` C library.

## Project Overview

`Libgnss_Coding` provides efficient Swift implementations for various Cyclic Redundancy Check (CRC) algorithms and Hamming decoding, essential for processing GNSS data streams (e.g., SBAS, RTCM3, NovAtel, L1 C/A).

### Key Features
- **CRC Algorithms:** CRC-16 (CCITT-FALSE), CRC-24 (Generic & 24Q), and CRC-32 (Standard/NovAtel).
- **Error Correction:** Hamming (32, 26) decoding and parity generation for L1 C/A navigation data (IS-GPS-200).
- **Performance:** Optimized implementations utilizing lookup tables and native Swift bitwise operations (e.g., `nonzeroBitCount`).
- **Logging:** Callback-based logging framework with configurable levels.

## Directory Structure

- `Sources/Libgnss_Coding/`: Core implementation.
  - `CRC.swift`: CRC algorithm implementations.
  - `Hamming.swift`: Hamming parity and decoding logic.
  - `Logging.swift`: Flexible logging framework.
- `Tests/Libgnss_CodingTests/`: XCTest cases verifying algorithm correctness against reference values.
- `docs/ALGORITHMS.md`: Mathematical specification of the implemented algorithms.

## Building and Running

### Prerequisites
- Swift 6.0+ toolchain (configured for Swift 6 language mode).

### Build Commands
- **Build:** `swift build`
- **Test:** `swift test`

## Development Conventions

- **Language:** Pure Swift (no external dependencies).
- **Concurrency:** Thread-safe logging utilizing `Sendable` and `@unchecked Sendable` where appropriate for Swift 6 compatibility.
- **Naming:** Follows Swift API Design Guidelines (`Libgnss_Coding` module name).
- **Integration:** Integrated via Swift Package Manager (SPM).

## Related Projects

- **libgnss-coding:** The underlying C library providing the reference implementation. Located in the sibling directory `../libgnss-coding`.

## Status
- [x] Initialize Swift Package.
- [x] Implement native Swift versions of CRC and Hamming algorithms.
- [x] Port unit tests from the C library to XCTest.
- [x] Implement thread-safe logging framework.
- [x] Port technical documentation.
