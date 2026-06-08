import Foundation

/// Hamming (32, 26) Parity Algorithms for GNSS
///
/// Provides implementations for parity check and generation as specified in
/// IS-GPS-200 for L1 C/A navigation data.
public enum Hamming {
    
    private static let hamming: [UInt32] = [
        0xBB1F3480, 0x5D8F9A40, 0xAEC7CD00,
        0x5763E680, 0x6BB1F340, 0x8B7A89C0
    ]
    
    /// Check parity and decode a 30-bit GPS L1 C/A navigation word.
    ///
    /// Decodes the 24 data bits from a 30-bit word and verifies the 6 parity bits.
    ///
    /// - Parameters:
    ///   - word: The 32-bit word containing the 30-bit navigation word (Bits 0-29).
    /// - Returns: Decoded 24 data bits (3 bytes) if parity is valid, nil otherwise.
    public static func decodeL1CAWord(_ word: UInt32) -> [UInt8]? {
        var w: UInt32
        var parity: UInt32 = 0
        var mutableWord = word
        
        // If the last bit of the previous word is set (D30*), the data is flipped.
        if (mutableWord & 0x40000000) != 0 {
            mutableWord ^= 0x3FFFFFC0
        }
        
        for i in 0..<6 {
            parity <<= 1
            w = (mutableWord & hamming[i]) >> 6
            // Check parity of w
            if w.nonzeroBitCount % 2 != 0 {
                parity ^= 1
            }
        }
        
        if parity != (mutableWord & 0x3F) {
            return nil
        }
        
        var data = [UInt8](repeating: 0, count: 3)
        for i in 0..<3 {
            data[i] = UInt8((mutableWord >> (22 - i * 8)) & 0xFF)
        }
        return data
    }
    
    private static let bmask: [UInt32] = [
        0x3B1F3480, 0x1D8F9A40, 0x2EC7CD00,
        0x1763E680, 0x35DFE480, 0x2BB1F340
    ]
    
    /// Compute the 6 parity bits for a GPS L1 C/A word (Version 0).
    /// Traditional bit-wise implementation of the parity algorithm.
    ///
    /// - Parameters:
    ///   - sbfmWord: The word containing data bits (d1-d24 in bits 6-29) and
    ///               previous word bits (d29*, d30* in bits 31, 30).
    ///   - isTLM: True if this is the TLM word (applies bit 6/7 inversion).
    /// - Returns: The complete 30-bit encoded word (Bits 0-29).
    public static func calcChecksumV0(_ sbfmWord: UInt32, isTLM: Bool) -> UInt32 {
        var d = sbfmWord & 0x3FFFFFC0
        let b29 = (sbfmWord >> 31) & 0x1
        let b30 = (sbfmWord >> 30) & 0x1
        
        if isTLM {
            if (UInt32(b30) + UInt32((bmask[4] & d).nonzeroBitCount)) % 2 != 0 {
                d ^= (0x1 << 6)
            }
            if (UInt32(b29) + UInt32((bmask[5] & d).nonzeroBitCount)) % 2 != 0 {
                d ^= (0x1 << 7)
            }
        }
        
        var wordj = d
        if b30 != 0 {
            wordj ^= 0x3FFFFFC0
        }
        
        wordj |= UInt32((UInt32(b29) + UInt32((bmask[0] & d).nonzeroBitCount)) % 2) << 5
        wordj |= UInt32((UInt32(b30) + UInt32((bmask[1] & d).nonzeroBitCount)) % 2) << 4
        wordj |= UInt32((UInt32(b29) + UInt32((bmask[2] & d).nonzeroBitCount)) % 2) << 3
        wordj |= UInt32((UInt32(b30) + UInt32((bmask[3] & d).nonzeroBitCount)) % 2) << 2
        wordj |= UInt32((UInt32(b30) + UInt32((bmask[4] & d).nonzeroBitCount)) % 2) << 1
        wordj |= UInt32((UInt32(b29) + UInt32((bmask[5] & d).nonzeroBitCount)) % 2)
        
        if b30 != 0 {
            wordj ^= 0x0000003F
        }
        
        return wordj & 0x3FFFFFFF
    }
    
    private static let parities: [UInt8] = [
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x13, 0x25,
        0x0B, 0x16, 0x0D, 0x1F, 0x35, 0x23, 0x0B, 0x1E,
        0x3E, 0x3D, 0x38, 0x31, 0x23, 0x07, 0x0D, 0x1A,
        0x37, 0x2F, 0x1C, 0x3B, 0x2D, 0x29, 0x16, 0x2A
    ]
    
    /// Compute the 6 parity bits for a GPS L1 C/A word (Version 1).
    /// Optimized version using a precomputed parity table.
    public static func calcChecksumV1(_ sbfmWord: UInt32, isTLM: Bool) -> UInt32 {
        var d = sbfmWord & 0x3FFFFFC0
        let b29 = (sbfmWord >> 31) & 0x1
        let b30 = (sbfmWord >> 30) & 0x1
        
        if isTLM {
            if (UInt32(b30) + UInt32((bmask[4] & d).nonzeroBitCount)) % 2 != 0 {
                d ^= (0x1 << 6)
            }
            if (UInt32(b29) + UInt32((bmask[5] & d).nonzeroBitCount)) % 2 != 0 {
                d ^= (0x1 << 7)
            }
        }
        
        let wordj = d
        var p: UInt8 = 0
        if b29 != 0 { p ^= parities[31] }
        if b30 != 0 { p ^= parities[30] }
        
        for i in 6..<30 {
            if (wordj & (1 << i)) != 0 {
                p ^= parities[i]
            }
        }
        
        var result = wordj | UInt32(p)
        if b30 != 0 {
            result ^= 0x3FFFFFC0
        }
        
        return result & 0x3FFFFFFF
    }
}
