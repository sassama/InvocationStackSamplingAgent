//
//  Callable.swift
//  InvocationStackSamplingAgent
//
//  Created by Matteo Sassano on 05.05.17.
//  Copyright © 2017 Matteo Sassano. All rights reserved.
//

import Foundation

class Callable: NSObject {
    
    var id : UInt64
    
    var parentId : UInt64?
    
    var childrenIds : [UInt64]?
    
    /// Defines the name of the callable function
    var name : String
    
    /// Describes the virtual memory address were the calable function is stored in
    var memoryAddress : UInt
    
    /// Describes the object/class holding the method
    var holder : String
    
    /// Describes the framework where the method is located in
    /// By default the framework is the project name.
    /// UIViewController functions e.g. are storing UIKit here
    var framework : String
    
    var threadName : String?
    
    var estimatedDuration : UInt64?
    
    var estimatedStartTime : UInt64?
    
    var lastTrackedTime : UInt64?
    
    var estimatedEndTime : UInt64?
    
    var ended : Bool = false
    
    init(name: String, holder: String) {
        self.id = Util.calculateUniqueId()
        self.name = name
        self.holder = holder
        self.memoryAddress = 0
        self.framework = ""
        self.threadName = Thread.current.description
    }
    
    init(name: String, memoryAddress: UInt, holder: String) {
        self.id = Util.calculateUniqueId()
        self.name = name
        self.holder = holder
        self.memoryAddress = memoryAddress
        self.framework = ""
        self.threadName = Thread.current.description
    }
    
    init(name: String, memoryAddress: UInt, holder: String, framework: String) {
        self.id = Util.calculateUniqueId()
        self.name = name
        self.holder = holder
        self.memoryAddress = memoryAddress
        self.framework = framework
        self.threadName = Thread.current.description
    }
    
    override var description: String {
        return "\(holder).\(name)\n\(framework)\n\(memoryAddress)\n"
    }

}
