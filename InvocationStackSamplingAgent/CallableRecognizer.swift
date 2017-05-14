//
//  SymbolRecognizer.swift
//  InvocationStackSamplingAgent
//
//  Created by Matteo Sassano on 13.05.17.
//  Copyright © 2017 Matteo Sassano. All rights reserved.
//

import UIKit

class CallableRecognizer: NSObject {
    
    var oldCallableBuffer : [Callable]
    var actualCallableBuffer : [Callable]
    var closedCallables : [Callable]
    
    override init() {
        oldCallableBuffer = [Callable]()
        actualCallableBuffer = [Callable]()
        closedCallables = [Callable]()
    }
    
    func copyToActialBuffer(stack: [Callable]) {
        actualCallableBuffer = stack
    }
    
    func overrideOldBuffer() {
        oldCallableBuffer = actualCallableBuffer
    }
    
    private func updateCallable(index: Int) {
        actualCallableBuffer[index].id = oldCallableBuffer[index].id
        actualCallableBuffer[index].parentId = oldCallableBuffer[index].parentId
        actualCallableBuffer[index].childrenIds = oldCallableBuffer[index].childrenIds
        actualCallableBuffer[index].estimatedStartTime = oldCallableBuffer[index].estimatedStartTime
        oldCallableBuffer[index].lastTrackedTime = actualCallableBuffer[index].lastTrackedTime
    }
    
    private func updateChildren(index: Int) {
        var children = oldCallableBuffer[index - 1].childrenIds
        children?.append(actualCallableBuffer[index].id)
        oldCallableBuffer[index - 1].childrenIds = children
        actualCallableBuffer[index - 1].childrenIds = children
    }
    
    private func closeCallable(index: Int) {
        if oldCallableBuffer.count < index {
            print("ERROR OUTOFBOUNDS: oldCallableBuffer")
            return
        }
        oldCallableBuffer[index].estimatedEndTime = oldCallableBuffer[index].lastTrackedTime
        if let endTime = oldCallableBuffer[index].estimatedEndTime, let startTime = oldCallableBuffer[index].estimatedStartTime {
            oldCallableBuffer[index].estimatedDuration = endTime - startTime
        }
        oldCallableBuffer[index].ended = true
        closedCallables.append(oldCallableBuffer[index])
    }
    
    func recognizeEqualCallable() {
        if oldCallableBuffer.count == 0 {
            return
        }
        var lastEqualCallable : Int?
        for (index, element) in oldCallableBuffer.enumerated() {
            if actualCallableBuffer.count > index {
                if element.name == actualCallableBuffer[index].name,
                    element.memoryAddress == actualCallableBuffer[index].memoryAddress {
                    updateCallable(index: index)
                    lastEqualCallable = index
                } else {
                    if let lastEqual = lastEqualCallable {
                        if index == lastEqual + 1 {
                            updateChildren(index: index)
                        }
                    }
                    closeCallable(index: index)
                }
            } else {
                closeCallable(index: index)
            }
        }
    }

}
