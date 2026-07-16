# Libgnss_Coding

[![CI](https://github.com/shuwang1/Orientable-libgnss-coding/actions/workflows/ci.yml/badge.svg)](https://github.com/shuwang1/Orientable-libgnss-coding/actions/workflows/ci.yml)[![codecov](https://codecov.io/github/shuwang1/libgnss-coding/graph/badge.svg?token=O8FK48JH03)](https://codecov.io/github/shuwang1/libgnss-coding)[![pages-build-deployment](https://github.com/shuwang1/Orientable-libgnss-coding/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/shuwang1/Orientable-libgnss-coding/actions/workflows/pages/pages-build-deployment)

A high-performance Swift library for GNSS-related coding and parity check algorithms, based on the robust `libgnss-coding` C library.

## Overview

`Libgnss_Coding` provides efficient, pure-Swift implementations for processing Global Navigation Satellite System (GNSS) data streams. It includes optimized Cyclic Redundancy Check (CRC) implementations and Hamming parity decoding algorithms as specified in international standards (e.g., IS-GPS-200).

## Key Features

*   **Error Detection (CRC):**
    *   **CRC-16:** CCITT-FALSE (Polynomial `0x1021`)
    *   **CRC-24:** Generic bit-wise calculation
    *   **CRC-24Q:** Qualcomm optimized table-based calculation (SBAS, RTCM3)
    *   **CRC-32:** Standard/NovAtel (Polynomial `0xEDB88320`)
*   **Error Correction (Hamming):**
    *   **Hamming (32, 26):** Decoding and parity generation for L1 C/A navigation data.
*   **Modern Swift:** Native implementations leveraging `nonzeroBitCount` for performance and bitwise efficiency.
*   **Thread-Safe Logging:** Configurable, callback-based diagnostic logger utilizing Swift 6 concurrency (`Sendable`).

## Installation

See [INSTALL.md](INSTALL.md) for detailed instructions on adding this package to your project via Swift Package Manager.

## Usage Example

### CRC-32 Calculation
```swift
import Libgnss_Coding
import Foundation

let data = "GNSS".data(using: .ascii)!
let parity = CRC.calcCRC32(data)
print(String(format: "0x%08X", parity))
// Output: 0x1F33C297
```

### Hamming L1 C/A Decoding
```swift
import Libgnss_Coding

let word: UInt32 = 0x22C0011A
if let decodedBytes = Hamming.decodeL1CAWord(word) {
    print("Decoded data: \(decodedBytes)")
} else {
    print("Parity error!")
}
```

## Documentation

Full API documentation is available via Swift-DocC. Build it directly from Xcode (**Product > Build Documentation**) or using the Swift CLI:

```bash
swift package generate-documentation --target Libgnss_Coding
```

## Related Projects

*   [libgnss-coding](../libgnss-coding): The underlying C library providing the original reference implementation.
