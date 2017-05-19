//
//  Agent.swift
//  InvocationStackSamplingAgent
//
//  Created by Matteo Sassano on 08.05.17.
//  Copyright © 2017 Matteo Sassano. All rights reserved.
//

import Foundation
import Darwin

class Agent: NSObject {
    
    /// Strores the Agent properties
    var agentProperties: [String: Any]?
    
    let stackSampler: CallStackSampler
    
    static var mainThreadID: pthread_t?
    
    init(properties: [(String, Any)]? = nil) {
        Agent.mainThreadID = pthread_self()
        agentProperties = [String: Any]()
        if let properties = properties {
            for (property, value) in properties {
                if Agent.allowedProperty(property: property) {
                    agentProperties?["property"] = value
                }
            }
        }
        stackSampler = CallStackSampler()
    }
    
    func setAgentConfiguration(properties: [(String, Any)]? = nil) {
        if let properties = properties {
            for (property, value) in properties {
                if Agent.allowedProperty(property: property) {
                    agentProperties?["property"] = value
                }
            }
        }
    }
    
    func startAgent() {
        stackSampler.timer.invalidate()
        stackSampler.initializeTimer()
    }
    
    func startAndReturnAgent() -> Agent {
        startAgent()
        return self
    }
    
    func stopAgent() {
        //stackSampler.timer.invalidate()
    }
    
    /// TODO:
    static func allowedProperty(property: String) -> Bool {
        return true
    }

}
