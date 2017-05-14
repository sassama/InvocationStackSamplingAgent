//
//  StackSampler.swift
//  InvocationStackSamplingAgent
//
//  Created by Matteo Sassano on 05.05.17.
//  Copyright © 2017 Matteo Sassano. All rights reserved.
//

import UIKit

class StackSymbolMapper: NSObject {
    
    var callableMap : [UInt64 : Callable]?
    
    //var probableChildId : UInt64?
    
    func getStackSymbols() -> [String] {
        return Thread.callStackSymbols
    }
    
    func getStackReturnAddresses() -> [UInt] {
        return Thread.callStackReturnAddresses as [UInt]
    }
    
    func getActualCallableStack() -> [Callable]? {
        let addresses = self.getStackReturnAddresses()
        var callables = [Callable]()
        var probableChildId : UInt64?
        for a in addresses {
            let addressInfo = AddressInfo(address: a)
            let callable = Callable(name: addressInfo.symbol, memoryAddress: addressInfo.address, holder: addressInfo.image)
            if let child = probableChildId {
                if callable.childrenIds == nil {
                    callable.childrenIds = [UInt64]()
                } else {
                    callable.parentId = callable.id
                }
                callable.childrenIds?.append(child)
                let child = callables.removeLast()
                child.parentId = callable.id
                callables.append(child)
            }
            callable.estimatedStartTime = Util.getTimestamp()
            callable.lastTrackedTime = callable.estimatedStartTime
            probableChildId = callable.id
            callables.append(callable)
        }
        if callables.count == 0 {
            return nil
        }
        return callables
    }
    
}
