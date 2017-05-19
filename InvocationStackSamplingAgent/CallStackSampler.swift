//
//  CallStackSampler.swift
//  InvocationStackSamplingAgent
//
//  Created by Matteo Sassano on 14.05.17.
//  Copyright © 2017 Matteo Sassano. All rights reserved.
//

import Foundation

class CallStackSampler: NSObject {
    
    var timer : Timer
    static let defaultTimeInterval = 0.05
    
    var stackSymbolMapper : StackSymbolMapper
    var callableRecognizer : CallableRecognizer
    
    override init() {
        timer = Timer()
        stackSymbolMapper = StackSymbolMapper()
        callableRecognizer = CallableRecognizer()
    }
    
    func initializeTimer(timeInterval: TimeInterval? = defaultTimeInterval) {
         performSampling()
//        timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(rawValue: UInt(0)), queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive))
//        timer.scheduleRepeating(deadline: DispatchTime.now(), interval: DispatchTimeInterval.milliseconds(50), leeway: DispatchTimeInterval.seconds(0))
//        timer.setEventHandler { [weak self] in
//            print("jvvjgvhc")
//            self?.performSampling()
//            
//        }
//        timer.resume()
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(CallStackSampler.defaultTimeInterval), target: self, selector: #selector(self.performSampling), userInfo: nil, repeats: true);
    
    }
    
    func performSampling() {
        // let a = self.stackSymbolMapper.getActualCallableStack()
        print("DONE")
        DispatchQueue.main.async {
            print("SAMPLIIIIIIIIIING")
            if let actualStack = self.stackSymbolMapper.getActualCallableStack() {
                self.callableRecognizer.copyToActialBuffer(stack: actualStack)
                self.callableRecognizer.recognizeEqualCallable()
            }
        }
    }

}
