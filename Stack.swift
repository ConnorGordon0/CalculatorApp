/*
 * Aaron Marlowe, Connor Gordon
 * Code for Generic Stack Struct
 * Version: 1.0
 * Last Modified: 1-27-17
 */

import UIKit

struct Stack<T> {
    
    var stackArray: [T] //Array to hold
    var arrayIndex: Int = -1
    
    
    init(){
        
        stackArray = []
    }
    
    //Function to clear the current stack's contents, and reset the arrayIndex
    mutating func clearStack()
    {
        self.stackArray.removeAll()
        self.arrayIndex = -1
    }
    
    
    
    /* Function to return if the Stack is Empty
     * Pre-condition: The Stack Exists
     * Post-condition: Returns true if the stack is empty
     */
    func isEmptyStack() -> Bool {
        
        return (self.arrayIndex == -1)
    }
    
    
    /* Function to return the top of the stack
     * Pre-condition: None
     * Post-condition: Top of stack is returned without popping
     if stack is empty, nil is returned
     */
    func Peek() -> T? {
        
        if(!self.isEmptyStack())
        {
            return self.stackArray[arrayIndex]
        }
        else
        {
            return nil
        }
    }
    
    /*Function to push an object of type T to stack
     * Pre-condition: None
     * Post-condition: pushObject is pushed onto stack.
     arrayIndex is incremented
     */
    mutating func Push(pushObject: T) {
        
        self.stackArray.append(pushObject)
        self.arrayIndex = self.arrayIndex + 1
    }
    
    
    /* Function to pop and return top element of the array
     * Pre-condition: None
     * Post-condition: The top element of the array is popped and
     returned
     If the array is empty, nil is returned
     If non-empty, arrayIndex is decremented
     */
    mutating func Pop() -> T? {
        
        if(!self.isEmptyStack())
        {
            arrayIndex = arrayIndex - 1
            return self.stackArray.popLast()!
        }
        else
        {
            return nil
        }
    }
}
