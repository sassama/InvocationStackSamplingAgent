//
//  AddressInfo.swift
//  InvocationStackSamplingAgent
//
//  Created by Matteo Sassano on 13.05.17.
//  Copyright © 2017 Matteo Sassano. All rights reserved.
//

import Foundation

class AddressInfo: NSObject {
    
    private let info: dl_info
    
    public let address: UInt
    
    public init(address: UInt) {
        self.address = address
        var i = dl_info()
        dladdr(UnsafeRawPointer(bitPattern: address), &i)
        self.info = i
    }
    
    /// -returns: the "image" (shared object pathname) for the instruction
    public var image: String {
        if let dli_fname = info.dli_fname, let fname = String(validatingUTF8: dli_fname), let _ = fname.range(of: "/", options: .backwards, range: nil, locale: nil) {
            return (fname as NSString).lastPathComponent
        } else {
            return "???"
        }
    }
    
    /// - returns: the symbol nearest the address
    public var symbol: String {
        if let dli_sname = info.dli_sname, let sname = String(validatingUTF8: dli_sname) {
            return sname
        } else if let dli_fname = info.dli_fname, let _ = String(validatingUTF8: dli_fname) {
            return self.image
        } else {
            return String(format: "0x%1x", UInt(bitPattern: info.dli_saddr))
        }
    }

}
