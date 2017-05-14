//
//  ViewController.swift
//  InvocationStackSamplingAgent
//
//  Created by Matteo Sassano on 05.05.17.
//  Copyright © 2017 Matteo Sassano. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        dosomething2("bla")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    func dosomething2(_ message: String) {
        print("dosomething2")
        
        let stackMapper = StackSymbolMapper()
        let stack : [UInt] = stackMapper.getStackReturnAddresses()
        for s in stack {
            _ = AddressInfo(address: UInt(s))
            //print(aInfo.symbol)
        }
        
        if let callables = stackMapper.getActualCallableStack() {
            for c in callables {
                print(c)
            }
        }
    }


}

