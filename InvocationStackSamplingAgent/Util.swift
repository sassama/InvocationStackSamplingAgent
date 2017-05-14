//
//  Util.swift
//  InvocationStackSamplingAgent
//
//  Created by Matteo Sassano on 08.05.17.
//  Copyright © 2017 Matteo Sassano. All rights reserved.
//

import UIKit

class Util: NSObject {
    
    static let defaultMultiplier = 1000000.0

    static func condenseWhitespace(string: String) -> String {
        return string.components(separatedBy: CharacterSet.whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
    
    /// Calculates a unique id for the usecase
    static func calculateUniqueId() -> UInt64 {
        let uuid1 : UInt64 = UInt64(UUID().hashValue)
        let uuid2 : UInt64 = UInt64(UUID().hashValue)
        return uuid1 << 0x20 | uuid2
    }
    
    static func getTimestamp(multiplier: Double? = defaultMultiplier) -> UInt64 {
        return UInt64(NSDate().timeIntervalSince1970 * multiplier!)
    }
    
    
}
