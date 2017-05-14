//
//  Agent.swift
//  InvocationStackSamplingAgent
//
//  Created by Matteo Sassano on 08.05.17.
//  Copyright © 2017 Matteo Sassano. All rights reserved.
//

import UIKit

class Agent: NSObject {
    
    /// Holds Agent singleton
    static var agent: Agent!
    
    /// Strores the Agent properties
    var agentProperties: [String: Any]?
    
    private override init() {
        agentProperties = [String: Any]()
    }
    
    static func configureAgent(properties: [(String, Any)]? = nil) -> Agent {
        let agent = Agent.getInstance()
        if let properties = properties {
            for (property, value) in properties {
                if agent.allowedProperty(property: property) {
                    agent.agentProperties?["property"] = value
                }
            }
        }
        return agent
    }
    
    /// Returns the hold Agent instance or a new one if one is not existing
    /// - returns: Agent instance
    static func getInstance() -> Agent {
        if agent != nil {
            return agent
        } else {
            return Agent()
        }
    }
    
    /// TODO:
    func allowedProperty(property: String) -> Bool {
        return true
    }

}
