//
//  StackFrame.swift
//  InvocationStackSamplingAgent
//
//  Created by Matteo Sassano on 15.05.17.
//  Copyright © 2017 Matteo Sassano. All rights reserved.
//

import UIKit
import Darwin

struct StackFrame {
    /// The underlying data of the struct is a basic UInt. A value of 0 represents an invalid frame.
    public let address: UInt
    
    /// The return address is pushed onto the stack immediately ahead of the previous frame pointer. If `self.address` is `0` this will return `0`
    /// - returns: the return address for the stack frame identified by `address`
    public var returnAddress: UInt { get {
        guard address != 0 else { return 0 }
        return UnsafeMutablePointer<UInt>(bitPattern: address)!.advanced(by: FP_LINK_OFFSET).pointee
        } }
    
    /// Preferred constructor gives the "current" StackFrame (where "current" refers to the frame that invokes this function). Also returns the `stackBounds` for use in subsequent calls to `next`.
    /// - returns: a `StackFrame` representing the caller's stack frame and `stackBounds` which should be passed into any future calls to `next`.
    @inline(never)
    public static func current() -> (frame: StackFrame, stackBounds: ClosedRange<UInt>) {
        let stackBounds = currentStackBounds()
        let frame = StackFrame(address: frame_address())
        
        if !stackBounds.contains(frame.address) || !isAligned(frame.address) {
            return (StackFrame(address: 0), stackBounds: stackBounds);
        }
        
        return (frame: frame.next(inBounds: stackBounds), stackBounds: stackBounds)
    }
    
    /// Follow the frame link pointer and return the result as another StackFrame.
    /// - returns: a `StackFrame` representing the stack frame after self, if it exists and is valid.
    public func next(inBounds stackBounds: ClosedRange<UInt>) -> StackFrame {
        guard address != 0 else { return self }
        let nextFrameAddress = UnsafeMutablePointer<UInt>(bitPattern: address)?.pointee
        if !stackBounds.contains(nextFrameAddress!) || !isAligned(nextFrameAddress!) || (nextFrameAddress ?? 0) <= address {
            return StackFrame(address: 0)
        }
        
        return StackFrame(address: nextFrameAddress!)
    }
    
}

// These values come from:
// http://www.opensource.apple.com/source/Libc/Libc-997.90.3/gen/thread_stack_pcs.c
#if arch(x86_64)
let ISALIGNED_MASK: UInt = 0xf
let ISALIGNED_RESULT: UInt = 0
let FP_LINK_OFFSET = 1
#elseif arch(i386)
let ISALIGNED_MASK: UInt = 0xf
let ISALIGNED_RESULT: UInt = 8
let FP_LINK_OFFSET = 1
#elseif arch(arm) || arch(arm64)
let ISALIGNED_MASK: UInt = 0x1
let ISALIGNED_RESULT: UInt = 0
let FP_LINK_OFFSET = 1
#endif

/// Use the pthread functions to get the bounds of the current stack as a closed interval.
/// - returns: a closed interval containing the memory address range for the current stack
private func currentStackBounds() -> ClosedRange<UInt> {
    let currentThread = Agent.mainThreadID
    
    let t = UInt(bitPattern: pthread_get_stackaddr_np(currentThread!))
    return ((t - UInt(bitPattern: pthread_get_stacksize_np(currentThread!))) ... t)
}

/// We traverse the stack using "downstack links". To avoid problems with these links, we ensure that frame pointers are "aligned" (valid stack frames are 16 byte aligned on x86 and 2 byte aligned on ARM).
/// - parameter address: the address to analyze
/// - returns: true if `address` is aligned according to stack rules for the current architecture
private func isAligned(_ address: UInt) -> Bool {
    return (address & ISALIGNED_MASK) == ISALIGNED_RESULT
}
