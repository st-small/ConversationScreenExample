//
//  UUID+Extensions.swift
//  SwiftUITableViewExample
//
//  Created by ~Akhtamov on 8/14/23.
//

import Foundation

extension UUID {
    func hashToInt() -> Int {
        var intValue: Int = 0
        withUnsafeBytes(of: self) { buffer in
            for byte in buffer {
                intValue = (intValue << 8) | Int(byte)
            }
        }
        return intValue
    }
}
