# GNSS Algorithms Specification

This document provides the mathematical and technical background for the algorithms implemented in `libgnss-coding`.

## Cyclic Redundancy Checks (CRC)

### CRC-24Q (Qualcomm)
Used extensively in SBAS and RTCM3 network streams.
*   **Polynomial:** `0x1864CFB` ($x^{24} + x^{23} + x^{18} + x^{17} + x^{14} + x^{11} + x^{10} + x^7 + x^6 + x^5 + x^4 + x^3 + x^1 + 1$)
*   **Initial Value:** `0x000000`
*   **Input/Output Reflection:** False (Big Endian processing)
*   **Final XOR:** `0x000000`

### CRC-32 (Standard/NovAtel)
Used for OEM7/SMART2 binary logs.
*   **Polynomial (Normal):** `0x04C11DB7`
*   **Polynomial (Reversed):** `0xEDB88320`
*   **Initial Value:** `0x00000000` (Note: Standard ZIP/Ethernet CRC uses `0xFFFFFFFF`)
*   **Final XOR:** `0x00000000`

## Hamming (32, 26) Parity
Implemented as specified in **IS-GPS-200** for GPS L1 C/A navigation data. Each 30-bit word consists of 24 data bits ($d_1$ to $d_{24}$) and 6 parity bits ($D_{25}$ to $D_{30}$).

### Parity Equations
The parity bits are calculated using the following equations (modulo 2 sum):
*   D25 = d29* XOR d1 XOR d2 XOR d3 XOR d5 XOR d6 XOR d10 XOR d11 XOR d12 XOR d13 XOR d14 XOR d17 XOR d18 XOR d20 XOR d23
*   D26 = d30* XOR d2 XOR d3 XOR d4 XOR d6 XOR d7 XOR d11 XOR d12 XOR d13 XOR d14 XOR d15 XOR d18 XOR d19 XOR d21 XOR d24
*   D27 = d29* XOR d1 XOR d3 XOR d4 XOR d5 XOR d7 XOR d8 XOR d12 XOR d13 XOR d14 XOR d15 XOR d16 XOR d19 XOR d20 XOR d22
*   D28 = d30* XOR d2 XOR d4 XOR d5 XOR d6 XOR d8 XOR d9 XOR d13 XOR d14 XOR d15 XOR d16 XOR d17 XOR d20 XOR d21 XOR d23
*   D29 = d30* XOR d1 XOR d3 XOR d5 XOR d6 XOR d7 XOR d9 XOR d10 XOR d14 XOR d15 XOR d16 XOR d17 XOR d18 XOR d21 XOR d22 XOR d24
*   D30 = d29* XOR d3 XOR d5 XOR d6 XOR d8 XOR d9 XOR d10 XOR d11 XOR d13 XOR d15 XOR d19 XOR d22 XOR d23 XOR d24

Where d29* and d30* are the last two bits of the *previous* word.

### TLM Word Processing
For Telemetry (TLM) words, bits 6 and 7 of the encoded word are inverted if bit 30 of the previous word was set, to maintain parity coverage. This library handles this logic via the `nib` parameter in `calc_checksum` functions.
