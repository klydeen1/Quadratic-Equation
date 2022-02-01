//
//  QuadraticEquation.swift
//  Quadratic-Equation
//
//  Created by Katelyn Lydeen on 1/31/22.
//

import Foundation
import SwiftUI

class QuadraticEquation: NSObject, ObservableObject {
    // Initialize values and text for the quadratic equation terms a, b, and c
    var a = 0.0
    @Published var aString = ""
    var b = 0.0
    @Published var bString = ""
    var c = 0.0
    @Published var cString = ""
    
    // Initialize values and text for the equation solutions
    @Published var x1 = 0.0
    @Published var x2 = 0.0
    @Published var x1Prime = 0.0
    @Published var x2Prime = 0.0
    @Published var bestX1 = 0.0
    @Published var bestX2 = 0.0
    @Published var x1Text = ""
    @Published var x2Text = ""
    @Published var x1PrimeText = ""
    @Published var x2PrimeText = ""
    @Published var bestX1Text = ""
    @Published var bestX2Text = ""
    
    // Set the calculate button to enabled
    @Published var enableButton = true
    
    /// initWithRadius
    /// Initializes a quadratic equation of the form ax^2  + bx + c  =  0 and runs the functions to calculate it's solutions using the two given equations
    /// - Parameter passedA: the value of constant a in the equation (for the x^2 term)
    /// - Parameter passedB: the value of constant b (for the x term)
    /// - Parameter passedC: the value of constant c
    /// returns true to indicate the function has finished running
    func initWithValues(passedA: Double, passedB: Double, passedC: Double) async -> Bool {
        a = passedA
        b = passedB
        c = passedC
        let _ = await withTaskGroup(of: Void.self) { taskGroup in
            taskGroup.addTask {let _ = await self.calculateX1(a: self.a, b: self.b, c: self.c)}
            taskGroup.addTask {let _ = await self.calculateX2(a: self.a, b: self.b, c: self.c)}
            taskGroup.addTask {let _ = await self.calculateX1Prime(a: self.a, b: self.b, c: self.c)}
            taskGroup.addTask {let _ = await self.calculateX2Prime(a: self.a, b: self.b, c: self.c)}
            taskGroup.addTask {let _ = await self.calculateMostPrecise(a: self.a, b: self.b, c:self.c)}
        }
        await setButtonEnable(state: true)

        return true    }
    
    /// calculateX1
    /// Solves for the first root of the quadratic equation ax^2 + bx + c = 0 using the formula listed in the method
    /// - Parameter a: the quadratic coefficient of the quadratic equation
    /// - Parameter b: the linear coefficient of the quadratic equation
    /// - Parameter c: the constant in the quadratic equation
    /// returns calculatedX1, the value of the root
    func calculateX1(a: Double, b: Double, c: Double) async -> Double {
        //              __________
        //           | /  2
        // - b   +   |/ b   -  4ac
        // -----------------------
        //          2a


        let calculatedX1 = (-b + pow((pow(b,2.0) - 4*a*c),0.5)) / (2*a)
        let newX1Text = String(calculatedX1)
        
        await updateX1(x1TextString: newX1Text)
        await newX1Value(x1Value: calculatedX1)
        
        return calculatedX1
    }
    
    /// calculateX2
    /// Solves for the second root of the quadratic equation ax^2 + bx + c = 0 using the formula listed in the method
    /// - Parameter a: the quadratic coefficient of the quadratic equation
    /// - Parameter b: the linear coefficient of the quadratic equation
    /// - Parameter c: the constant in the quadratic equation
    /// returns calculatedX2, the value of the root
    func calculateX2(a: Double, b: Double, c: Double) async -> Double {
        //              __________
        //           | /  2
        // - b   -   |/ b   -  4ac
        // -----------------------
        //          2a


        let calculatedX2 = (-b - pow((pow(b,2.0) - 4*a*c),0.5)) / (2*a)
        let newX2Text = String(calculatedX2)
        
        await updateX2(x2TextString: newX2Text)
        await newX2Value(x2Value: calculatedX2)
        
        return calculatedX2
    }
    
    /// calculateX1Prime
    /// Solves for the first root of the quadratic equation ax^2 + bx + c = 0 using the alternate solution formula (listed in the method)
    /// - Parameter a: the quadratic coefficient of the quadratic equation
    /// - Parameter b: the linear coefficient of the quadratic equation
    /// - Parameter c: the constant in the quadratic equation
    /// returns calculatedX1Prime, the value of the root
    func calculateX1Prime(a: Double, b: Double, c: Double) async -> Double {
        //       - 2c
        // -------------------
        //          __________
        //       | /  2
        // b  +  |/ b   -  4ac

        let calculatedX1Prime = (-2*c) / (b + pow((pow(b,2.0) - 4*a*c),0.5))
        let newX1PrimeText = String(calculatedX1Prime)
        
        await updateX1Prime(x1PrimeTextString: newX1PrimeText)
        await newX1PrimeValue(x1PrimeValue: calculatedX1Prime)
        
        return calculatedX1Prime
    }
    
    /// calculateX2Prime
    /// Solves for the second root of the quadratic equation ax^2 + bx + c = 0 using the alternate solution formula (listed in the method)
    /// - Parameter a: the quadratic coefficient of the quadratic equation
    /// - Parameter b: the linear coefficient of the quadratic equation
    /// - Parameter c: the constant in the quadratic equation
    /// returns calculatedX2Prime, the value of the root
    func calculateX2Prime(a: Double, b: Double, c: Double) async -> Double {
        //       - 2c
        // -------------------
        //          __________
        //       | /  2
        // b  -  |/ b   -  4ac

        let calculatedX2Prime = (-2*c) / (b - pow((pow(b,2.0) - 4*a*c),0.5))
        let newX2PrimeText = String(calculatedX2Prime)
        
        await updateX2Prime(x2PrimeTextString: newX2PrimeText)
        await newX2PrimeValue(x2PrimeValue: calculatedX2Prime)
        
        return calculatedX2Prime
    }
    
    /// calculateMostPrecise
    /// Finds the most precise of the two possible solution sets for the quadratic equation of the form ax^2 + bx + c = 0
    /// - Parameter a: the quadratic coefficient of the quadratic equation
    /// - Parameter b: the linear coefficient of the quadratic equation
    /// - Parameter c: the constant in the quadratic equation
    /// returns the solutions for the roots in a tuple (x1, x2)
    func calculateMostPrecise(a: Double, b: Double, c: Double) async -> (Double, Double) {
        // To avoid subtractive cancellation, we want to add values together instead of subtracting
        // The sign of b is used to determine whether to add or subtract to find the first root
        // The second root can then be found using x2 = c/x1 (without losing precision)
        let calculatedX1: Double
        if b >= 0 {
            calculatedX1 = (-b - pow((pow(b,2.0) - 4*a*c),0.5)) / (2*a)
        } else {
            calculatedX1 = (-b + pow((pow(b,2.0) - 4*a*c),0.5)) / (2*a)
        }
        let calculatedX2 = c/(a*calculatedX1)
        
        let newBestX1Text = String(calculatedX1)
        let newBestX2Text = String(calculatedX2)
        await updateBestX1(bestX1TextString: newBestX1Text)
        await newBestX1Value(bestX1Value: calculatedX1)
        await updateBestX2(bestX2TextString: newBestX2Text)
        await newBestX2Value(bestX2Value: calculatedX2)
        
        return (calculatedX1, calculatedX2)
    }
    
    /// setButtonEnable
    /// Toggles the state of the Enable button
    /// - Parameter state: Boolean indicating whether the button should be enabled or not
    @MainActor func setButtonEnable(state: Bool) {
        if state {
            Task.init {
                await MainActor.run {
                    self.enableButton = true
                }
            }
        }
        else{
            Task.init {
                await MainActor.run {
                    self.enableButton = false
                }
            }
        }

    }
    
    /// updateX1
    /// Executes on the main thread to update the text that gives the value of x1
    /// - Parameter x1TextString: Text describing the value of x1
    @MainActor func updateX1(x1TextString: String){
        x1Text = x1TextString
    }
    
    /// newX1Value
    /// Updates the value of x1
    /// - Parameter x1Value: Double describing the value of x1
    @MainActor func newX1Value(x1Value: Double){
        self.x1 = x1Value
    }
    
    /// Same as above for x2
    @MainActor func updateX2(x2TextString: String){
        x2Text = x2TextString
    }
    @MainActor func newX2Value(x2Value: Double){
        self.x2 = x2Value
    }
    
    /// Same as above for x1Prime
    @MainActor func updateX1Prime(x1PrimeTextString: String){
        x1PrimeText = x1PrimeTextString
    }
    @MainActor func newX1PrimeValue(x1PrimeValue: Double){
        self.x1Prime = x1PrimeValue
    }
    
    /// Same as above for x2Prime
    @MainActor func updateX2Prime(x2PrimeTextString: String){
        x2PrimeText = x2PrimeTextString
    }
    @MainActor func newX2PrimeValue(x2PrimeValue: Double){
        self.x2Prime = x2PrimeValue
    }
    
    /// Same as above for the most precise x1
    @MainActor func updateBestX1(bestX1TextString: String){
        bestX1Text = bestX1TextString
    }
    @MainActor func newBestX1Value(bestX1Value: Double){
        self.bestX1 = bestX1Value
    }
    
    /// Same as above for the most precise x2
    @MainActor func updateBestX2(bestX2TextString: String){ bestX2Text = bestX2TextString }
    @MainActor func newBestX2Value(bestX2Value: Double){ self.bestX2 = bestX2Value }
}
