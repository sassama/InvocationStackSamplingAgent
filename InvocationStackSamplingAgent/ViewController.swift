//
//  ViewController.swift
//  InvocationStackSamplingAgent
//
//  Created by Matteo Sassano on 05.05.17.
//  Copyright © 2017 Matteo Sassano. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var agent : Agent!

    override func viewDidLoad() {
        super.viewDidLoad()
        agent = Agent()
        DispatchQueue.main.async {
            self.agent.startAgent()
        }
        DispatchQueue.main.async {
            self.dosomething()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dosomething() {
        // let i : UInt64 = 0
        var j : UInt64 = 0
        //while i < UInt64.max/64 {
            while j < 100 {
                print("\(j): dosomething")
                dosomething2()
                j = j + 1
            }
        //}
    }
    
    func dosomething2() {
        // let i : UInt64 = 0
        var j : UInt64 = 0
        //while i < UInt64.max/64 {
        while j < 100 {
            print("\(j): dosomething2")
            j = j + 1
        }
        //}
    }


}

