//
//  ViewController.swift
//  Calculator
//
//  Created by James Marlowe and Connor Gordon on 1/25/17.
//  Copyright © 2017 High Point University. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var calculatorDisplay: UILabel!
    
    //Button connections
    @IBOutlet weak var zeroButton: UIButton!
    @IBOutlet weak var decimalButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var divideButton: UIButton!
    @IBOutlet weak var multiplyButton: UIButton!
    @IBOutlet weak var equalButton: UIButton!
    @IBOutlet weak var modButton: UIButton!
    @IBOutlet weak var ACButton: UIButton!
    @IBOutlet weak var rightParen: UIButton!
    @IBOutlet weak var leftParen: UIButton!
    @IBOutlet weak var swapSign: UIButton!
    
    var numberStack   = Stack<Double>()    // stack variable to hold all numbers
    var operatorStack = Stack<Character>() // stack variable to hold all operators, plus '('
    var calculatedvalue: Double = 0.0      // Stores calculated value
    var repeatMath: Bool = false           // Bool for "=" button to repeat math
    
    typealias binops = (Double, Double)->Double // for doMath
    var ops: [String:binops] = [:]
    
    // boolean variables to manage showing numbers to the display at appropriate times
    var didPrecedence       = false
    var shouldClear         = false
    var decimalPressed      = false // true when the decimal button is pressed
    var consecutive_r_paren = false // true when the right paren is pressed twice at evaluation
    
    var parenOnStack = 0 // keeps track of the number of left parenthesis are on the operatorStack
    var lastOpPopped: Character = Character.init("$") // init character is arbitrary
    var lastValue: Double = 0.0
    
    //--------------------------- Helping Functions -----------------------------//
    
    /* disableButton(args: UIButton ...)
     * Function to enable/disable the buttons presented to it
     * If toggleEnable is true, all the buttons will be enabled. Otherwise, they will all be disabled
     * NOTE: Any amount of parameters may be passed to disableButton, as long as they are of type UIButton
     */
    //----------------------------------------------------------------------------------------------------
    func disableButton(toggleEnable: Bool, args: UIButton...)
    {
        for localButton: UIButton in args //go through arguments presented to function
        {
            localButton.isEnabled = toggleEnable
        }
    }
    
    // The following two functions (disableOperators and enableOperators) are just presets for convenience
    //----------------------------------------------------------------------------------------------------
    func disableOperators()
    {
        disableButton(toggleEnable: false, args: plusButton, minusButton, divideButton, multiplyButton,
                      equalButton)
    }
    
    //----------------------------------------------------------------------------------------------------
    func enableOperators()
    {
        disableButton(toggleEnable: true, args: plusButton, minusButton, divideButton, multiplyButton,
                      equalButton)
    }
    
    /*
     * precendece(op1, op2)
     * Function to determine the precedence between two operators
     * If op1 has greater precedence than op2, true is returned
     * If op2 has greater than or equal precedence than op1, false is returned
     */
    //----------------------------------------------------------------------------------------------------
    func precedence(_ op1: Character, _ op2: Character) -> Bool
    {
        if((op1 == "(") && (op2 != "("))
        {
            return true
        }
        else if((op1 == "*") || (op1 == "/"))
        {
            if((op2 == "+") || (op2 == "-"))
            {
                return true
            }
            else
            {
                return false
            }
        }
        else
        {
            return false
        }
    }
    
    /*
     * isOperator(Char) -> Bool
     * Function to return true if the parameter passed is == *,/,+, or -. False otherwise
     */
    //----------------------------------------------------------------------------------------------------
    func isOperator(_ localChar: Character) -> Bool
    {
        var localReturn: Bool = true
        
        switch(localChar)
        {
            case "*": break
            case "+": break
            case "/": break
            case "-": break
            
            default:
                localReturn = false
        }
        
        return localReturn
    }
    
    /*
     * getDisplayNumber() -> Double?
     * function to interperet the calculator's display as an integer, and returns it
     * If it can't be interpreted as an Int, nil is returned
     */
    //----------------------------------------------------------------------------------------------------
    func getDisplayNumber() -> Double?
    {
        let interpret = Double(calculatorDisplay.text!)
        return interpret
    }
    
    //Function to update the calculator's display to the toSend parameter
    //----------------------------------------------------------------------------------------------------
    func sendToDisplay(_ toSend: String)
    {
        calculatorDisplay.text = toSend
    }
    
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
    func div(_ a:Double,_ b:Double) -> Double
    {
        if b == 0
        {
            print("Error: Cannot Divide by 0. Setting display value to 0")
            return 0 // If the user decides to be cute and divide by 0.
        }
        else
        {
            return a / b
        }
    }
    
    // Calculation Function that does the operations
    //----------------------------------------------------------------------------------------------------
    func doMath(_ a:Double,_ b:Double,_ op:Character)-> Double
    {
       print("Doing Math: ", a, " ", op, " ", b)
       let opFunc = ops["\(op)"] // Sends the operation character
       return opFunc!(a,b)
    }
    
    // -------------------------- IBAction Functions --------------------------//
    
    // Function that gets triggered when 0-9 are pressed
    //----------------------------------------------------------------------------------------------------
    @IBAction func numberPressed(_ sender: UIButton)
    {
        // If the last operator updated the display by itself
        if((didPrecedence || shouldClear) && !decimalPressed)
        {
            shouldClear = false
            print("resetting display in numberPressed")
            sendToDisplay("")
        }
       // add the corresponding number to the display on the calculator
        
       calculatorDisplay.text = calculatorDisplay.text?.appending(sender.currentTitle!)
        
       disableButton(toggleEnable: false, args: leftParen)
       enableOperators()
        
        if(parenOnStack > 0) // so you can have stuff like 10 * (50)
        {
            print("Enabling right paren in numberPressed")
            disableButton(toggleEnable: true, args: rightParen)
        }
    }
    
    /*
     *  @IBAction func operatorPressed(UIButton)
     *  Function that is triggered when *,-,+, or / is pressed on the calculator
     *
     */
    //----------------------------------------------------------------------------------------------------
    @IBAction func operatorPressed(_ sender: UIButton)
    {
        let localOp = Character(sender.currentTitle!)
        let object = getDisplayNumber()! // the Double representation of what is on the Calculator Display
        
        decimalPressed = false // reset decimal bool flag
        disableButton(toggleEnable: true, args: decimalButton)
        
        disableButton(toggleEnable: true, args: leftParen) // enable parenthetical expressions
        disableButton(toggleEnable: false, args: rightParen)
        
        
        // first, send whatever number is on the display(if any) to the number stack
        if(!didPrecedence && !consecutive_r_paren)
        {
            numberStack.Push(pushObject: object)
            print("No precendence was done, sending ", object, " to numberStack")
            sendToDisplay("")
            
            consecutive_r_paren = false
        }
        else
        {
            consecutive_r_paren = false
            didPrecedence = false
            
            if(!numberStack.isEmptyStack() && numberStack.Peek()! != object)
            {
                numberStack.Push(pushObject: object)
                print("Precedence found, sending ", object, " to numberStack")
            }
            print("Precedence found, not sending anything to numberStack")
            
        }
        
        if(operatorStack.isEmptyStack() || (operatorStack.Peek()!) == "(") //if the operator stack is empty, or if a left parenthesis is there, push the operator onto the stack
        {
            operatorStack.Push(pushObject: localOp)
            ACButton.setTitle("C", for: .normal)
            
            //disable/enable appropriate buttons
            disableOperators()
            
            
        }
        else if(isOperator(operatorStack.Peek()!)) //if *,+,/,- is on the top of operator stack
        {
            if(precedence(localOp, operatorStack.Peek()!)) //incoming operator has higher precedence than existing one
            {
                didPrecedence = true
                print(localOp, " has greater precedence than ", operatorStack.Peek()!)
                operatorStack.Push(pushObject: localOp)
                
            }
            else
            {
                while(!operatorStack.isEmptyStack() && (operatorStack.Peek()! != "(") && (!precedence(localOp, operatorStack.Peek()!)))
                {
                
                    let secondNum = numberStack.Pop()
                    let firstNum = numberStack.Pop()
                
                    lastOpPopped = operatorStack.Pop()!
                    //Pop two numbers off the number stack, do the math on them, and push the result on the number stack
                    numberStack.Push(pushObject: doMath(firstNum!, secondNum!, lastOpPopped))
                    
                }
                
                operatorStack.Push(pushObject: localOp)
                
                //update the calculator display
                sendToDisplay(String(numberStack.Peek()!))
                shouldClear = true
            }
            
            ACButton.setTitle("C", for: .normal)
            
            //disable/enable appropriate buttons
            disableOperators()
        }
    }

    // Equals Function that gets called when the "=" button is pressed. 
    // It is called within the equalsPressed Function. This function will 
    // make the remaining calculation that is being held within the numberStack and
    // the operatorStack.
    //
    // The commented section is the prototype code for if Equals is pressed continually
    // Which should continually do the last known operation each time. 
    //----------------------------------------------------------------------------------------------------
    func equalOut()
    {
        /*
        if repeatMath
        {
            print("Repeat Math Called", repeatMath)
            calculatedvalue = numberStack.Pop()!
            calculatedvalue = doMath(calculatedvalue, lastValue, lastOpPopped)
            sendToDisplay(String(calculatedvalue)) // Updates the display with the new correct value
        }*/
        if operatorStack.isEmptyStack()
        {
            return
        }
        else
        {
            let object    = getDisplayNumber()!  // The Double representation of what is on the Calculator Display
            numberStack.Push(pushObject: object)
            lastValue     = numberStack.Pop()!   // Pops the Last known number value on the stack
            lastOpPopped  = operatorStack.Pop()! // Pops the last known Operator on the stack
            print("Last Popped Operator = ", lastOpPopped)
            
            
            print("lastOpPopped = ", lastOpPopped)
            print("Numberstack last position = ",numberStack.Peek()!)
            
            if !numberStack.isEmptyStack()
            {
                calculatedvalue = doMath(numberStack.Pop()!, lastValue, lastOpPopped) // Calculates the current value
                numberStack.Push(pushObject: calculatedvalue)         // Pushes that current value back onto the stack
                //operatorStack.Push(pushObject: lastOpPopped)          // Pushes the last used operator onto the stack
                
                sendToDisplay(String(calculatedvalue)) // Updates the display with the new correct value
                repeatMath = true
            }
        }
    }
    
    // The button caller for the "=" button. This button action will call the function equalOut()
    //----------------------------------------------------------------------------------------------------
    @IBAction func equalsPressed(_ sender: UIButton)
    {
        print("equals Pressed")
        equalOut()
    }
    
    //----------------------------------------------------------------------------------------------------
    @IBAction func decimalPoint(_ sender: UIButton)
    {
        decimalPressed = true
        disableOperators()
        disableButton(toggleEnable: false, args: decimalButton, rightParen, leftParen)
        
        calculatorDisplay.text = calculatorDisplay.text?.appending(".") //append a dot to Calculator display
    }
    
    // This function will swap the sign of th ecurrent number 
    // displayed onto the screen and will either make it positive 
    // or negative depending on the current value. This will be done
    // through multiplication instead of tacking on a negative like 
    // object = -object.
    //----------------------------------------------------------------------------------------------------
    @IBAction func negative(_ sender: UIButton)
    {
        var object    = getDisplayNumber()! // The Double representation of what is on the Calculator Display
        object = mult(-1.0, object)         // Multiply the current value by -1.0
        sendToDisplay(String(object))       // Update Display with new value
    }
    
    // When the clear button is pressed
    //----------------------------------------------------------------------------------------------------
    @IBAction func clearButton(_ sender: UIButton)
    {
        print("Clear button pressed")
        
        if(ACButton.currentTitle == "C") //Just clear the display
        {
            sendToDisplay("")
            ACButton.setTitle("AC", for: .normal)
        }
        else //the clear button has already been pressed once, and we want to clear the stacks as well
        {
            sendToDisplay("")
            
            numberStack.clearStack()
            operatorStack.clearStack()
            
            disableButton(toggleEnable: false, args: plusButton, minusButton, divideButton, multiplyButton,
                          equalButton, rightParen)
            disableButton(toggleEnable: true, args: decimalButton, leftParen)
            
            decimalPressed = false
            parenOnStack = 0
        }
    }
    
    // Function that gets called when either the '(' button or ')' button is pressed
    //----------------------------------------------------------------------------------------------------
    @IBAction func parenthesisPressed(_ sender: UIButton)
    {
        if(sender.currentTitle == "(") //left parenthesis pressed
        {
            operatorStack.Push(pushObject: "(")
            shouldClear = true
            parenOnStack += 1
            
            print("Pushing left parenthesis on stack")
            print("Number of l_paren on stack:", parenOnStack)
            
            disableButton(toggleEnable: true, args: rightParen)
            disableOperators()
            
        }
        else //right parenthesis pressed
        {
            disableButton(toggleEnable: false, args: leftParen)
            
            if(!(calculatorDisplay.text?.isEmpty)! && !consecutive_r_paren)
            {
                numberStack.Push(pushObject: getDisplayNumber()!)
            }
            
            while(operatorStack.Peek() != "(") //repeat this process while there are still nested operations
            {                                  //inside parenthesis
                
                let secondNumber = numberStack.Pop()!
                let firstNumber  = numberStack.Pop()!
                
                lastOpPopped = operatorStack.Pop()!
                numberStack.Push(pushObject: doMath(firstNumber, secondNumber, lastOpPopped))
            }
            
            lastOpPopped = operatorStack.Pop()! //get rid of matching parenthesis
            parenOnStack -= 1
            
            //update the calculator display
            if(numberStack.Peek() != nil)
            {
               sendToDisplay(String(numberStack.Peek()!))
               shouldClear = true
            }
            
            enableOperators()
            disableButton(toggleEnable: false, args: decimalButton)
            if(parenOnStack  <= 0)
            {
                disableButton(toggleEnable: false, args: rightParen)
            }
            
            print("Number of l_paren on stack:", parenOnStack)
            consecutive_r_paren = true
        }
    }
    
    //----------------------------------------------------------------------------------------------------
    override func viewDidLoad()
    {
        print("Calling viewDidLoad")
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        numberStack.clearStack()
        operatorStack.clearStack()
        
        calculatorDisplay.layer.cornerRadius = 8
        ACButton.titleLabel?.text = "AC"
        
        zeroButton.setTitleColor(UIColor.clear, for: UIControlState.disabled)
        decimalButton.setTitleColor(UIColor.clear, for: UIControlState.disabled)
        plusButton.setTitleColor(UIColor.clear, for: UIControlState.disabled)
        minusButton.setTitleColor(UIColor.clear, for: UIControlState.disabled)
        divideButton.setTitleColor(UIColor.clear, for: UIControlState.disabled)
        multiplyButton.setTitleColor(UIColor.clear, for: UIControlState.disabled)
        equalButton.setTitleColor(UIColor.clear, for: UIControlState.disabled)
        modButton.setTitleColor(UIColor.clear, for: UIControlState.disabled)
        ACButton.setTitleColor(UIColor.clear, for: UIControlState.disabled)
        rightParen.setTitleColor(UIColor.clear, for: UIControlState.disabled)
        leftParen.setTitleColor(UIColor.clear, for: .disabled)
        
        disableButton(toggleEnable: false, args: plusButton, minusButton, divideButton, multiplyButton,
                                                 equalButton, rightParen)
    }
    
    //----------------------------------------------------------------------------------------------------
    override func loadView()
    {
        super.loadView()
        
        ops = ["+": add,"-": sub, "*": mult, "/": div]
        
    }
    
    //----------------------------------------------------------------------------------------------------
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

