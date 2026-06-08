import Testing
import Foundation
@testable import Libgnss_Coding

@Suite("Libgnss_Coding Tests")
struct Libgnss_CodingTests {
    
    // MARK: - CRC Tests
    
    @Test("CRC-16 Basic Test")
    func calcCRC16Basic() {
        let data = "123456789".data(using: .ascii)!
        let result = CRC.calcCRC16(data)
        #expect(result == 0x31C3)
    }
    
    @Test("CRC-24Q Parameterized Tests", arguments: [
        // (Input Bytes, Expected CRC)
        ([UInt8]([0x01, 0x02, 0x03]), UInt32(0x428EB1)), // result -> 4361905
        ([0xD3, 0x00, 0x13, 0x3E, 0xD7, 0xD3, 0x02, 0x02, 0x98, 0x0E, 0xDE, 0xEF, 0x34, 0xB4, 0xBD, 0x62, 0xAC, 0x09, 0x41, 0x98, 0x6F], UInt32(0x9DB12F))
    ])
    func calcCRC24Q(data: [UInt8], expected: UInt32) {
        let result = CRC.calcCRC24Q(data)
        #expect(result == expected)
    }
    
    @Test("CRC-32 Parameterized Tests", arguments: [
        ("123456789", UInt32(0x2DFD2D88)),
        ("GNSS", UInt32(0x1F33CE97)) // Corrected: 523488919 = 0x1F33CE97
    ])
    func calcCRC32(input: String, expected: UInt32) {
        let data = input.data(using: .ascii)!
        let result = CRC.calcCRC32(data)
        #expect(result == expected)
    }
    
    @Test("CRC-32 NovAtel Header Test")
    func calcCRC32NovatelHeader() {
        let novatelHeader: [UInt8] = [
            0xAA, 0x44, 0x12, 0x1C, 0x01, 0x00, 0x02, 0x40,
            0x20, 0x00, 0x00, 0x00, 0x1D, 0x1D, 0x00, 0x00,
            0x00, 0x00, 0x00, 0x00, 0x2D, 0xA6
        ]
        let expectedCRC: UInt32 = 0x90D7E069
        let result = CRC.calcCRC32(novatelHeader)
        #expect(result == expectedCRC)
    }
    
    @Test("CRC-32 Table Value Verification", arguments: [
        (UInt32(0), UInt32(0x00000000)),
        (UInt32(1), UInt32(0x77073096)),
        (UInt32(128), UInt32(0xEDB88320))
    ])
    func calcCRC32Val(index: UInt32, expected: UInt32) {
        #expect(CRC.calcCRC32Val(index) == expected)
    }
    
    // MARK: - Hamming Tests
    
    @Test("Hamming L1 C/A Word Decoding - Invalid Parity")
    func decodeL1CAWordInvalid() {
        let word: UInt32 = 0x8BA00010
        let result = Hamming.decodeL1CAWord(word)
        #expect(result == nil)
    }
    
    @Test("Hamming Checksum Verification (V0 & V1)")
    func calcChecksumGPSSubframe() {
        let sbfmWord: UInt32 = 0x22C00100
        let expected: UInt32 = 0x22C0011A
        
        let resultV0 = Hamming.calcChecksumV0(sbfmWord, isTLM: false)
        let resultV1 = Hamming.calcChecksumV1(sbfmWord, isTLM: false)
        
        #expect(resultV0 == expected)
        #expect(resultV1 == expected)
    }
}
