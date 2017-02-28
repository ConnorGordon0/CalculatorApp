//
//  ViewController.swift
//  Calculator
//
//  Created by James Marlowe and Connor Gordon on 1/25/17.
//  Copyright © 2017 High Point University. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var calculatorDisplay: UILabel!
    
    typealias binop = (Double, Double)->Double
   // let ops: [String:binop] = ["+":add, "-":sub, "*":mult, "/":divi]
    
    //var opFunc = ops["+"]
    
    // Addition Function
    //-----------------------------------------------------
    func add(_ a:Double,_ b:Double) -> Double
    {
        return a + b
    }
    
    // Subtraction Function
    //-----------------------------------------------------
    func sub(_ a:Double,_ b:Double) -> Double
    {
        return a - b
    }
    
    // Multiplication Function
    //-----------------------------------------------------
    func mult(_ a:Double,_ b:Double) -> Double
    {
        return a * b
    }
    
    // Division Function
    //-----------------------------------------------------
    func divi(_ a:Double,_ b:Double) -> Double
    {
        return a / b
    }
    
    // Calculation Function that does the operations
    //-----------------------------------------------------
  /*  func doMath(_ a:Double,_ b:Double,_ op:Character)-> Double
    {
      //  let opFunc = ops["\(op)"] // Sends the operation character
     //   return opFunc!(a,b)
    }
    */
    //-----------------------------------------------------
    @IBAction func numberPressed(_ sender: UIButton)
    {
        
    }
    
    @IBAction func operatorPressed(_ sender: UIButton) {
    }
    
    @IBAction func equalsPressed(_ sender: UIButton) {
    }
    
    @IBAction func decimalPoint(_ sender: UIButton) {
    }
    
    @IBAction func negative(_ sender: UIButton) {
    }
    
    @IBAction func clearButton(_ sender: UIButton) {
    }
    
    //-----------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

