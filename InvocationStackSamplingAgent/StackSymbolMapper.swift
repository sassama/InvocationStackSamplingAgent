//
//  StackSampler.swift
//  InvocationStackSamplingAgent
//
//  Created by Matteo Sassano on 05.05.17.
//  Copyright © 2017 Matteo Sassano. All rights reserved.
//

import Foundation

class StackSymbolMapper: NSObject {
    
    // var callableMap : [UInt64 : Callable]?
    
    //var probableChildId : UInt64?
    
    func getStackSymbols() -> [String] {
        return Thread.callStackSymbols
    }
    
    func getStackReturnAddresses() -> [UInt] {
        // return callStackReturnAddresses()
        return Thread.callStackReturnAddresses as [UInt]
    }
    
    public func callStackReturnAddresses(skip: UInt = 0, maximumAddresses: Int = Int.max) -> [UInt] {
        guard maximumAddresses > 0 else { return [] }
        
        var result = [UInt]()
        var skipsRemaining = skip
        var addressesRemaining = maximumAddresses
        
        let maximumReserve = 32
        result.reserveCapacity(maximumAddresses < maximumReserve ? maximumAddresses : maximumReserve)
        
        var (frame, bounds) = StackFrame.current()
        var returnAddress = frame.returnAddress
        
        while returnAddress != 0 && addressesRemaining > 0 {
            if skipsRemaining > 0 {
                skipsRemaining -= 1
            } else {
                result.append(returnAddress)
                addressesRemaining -= 1
            }
            frame = frame.next(inBounds: bounds)
            returnAddress = frame.returnAddress
        }
        
        return result
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
