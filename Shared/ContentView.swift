//
//  ContentView.swift
//  Shared
//
//  Created by Katelyn Lydeen on 1/31/22.
//

import SwiftUI

struct ContentView: View {
    // Initialize an instance of the QuadraticEquation class called quadModel
    @ObservedObject private var quadModel = QuadraticEquation()
    
    // Initialize default values for a, b, and c shown in the UI
    @State var aString = "1.0"
    @State var bString = "1.0"
    @State var cString = "-2.0"
    var body: some View {
        // Display outputs on the UI
        VStack {
            HStack {
                VStack {
                    Text("Quadratic coefficient")
                        .padding(.top)
                        .padding(.bottom, 0)
                    TextField("Enter quadratic coefficient a", text: $aString, onCommit: {Task.init {await self.solveQuadratic()}})
                        .padding(.horizontal)
                        .frame(width: 100)
                        .padding(.top, 0)
                        .padding(.bottom, 30)
                }
                VStack {
                    Text("Linear coefficient")
                        .padding(.top)
                        .padding(.bottom, 0)
                    TextField("Enter linear coefficient b", text: $bString, onCommit: {Task.init {await self.solveQuadratic()}})
                        .padding(.horizontal)
                        .frame(width: 100)
                        .padding(.top, 0)
                        .padding(.bottom, 30)
                }
                VStack {
                    Text("Constant")
                        .padding(.top)
                        .padding(.bottom, 0)
                    TextField("Enter constant c", text: $cString, onCommit: {Task.init {await self.solveQuadratic()}})
                        .padding(.horizontal)
                        .frame(width: 100)
                        .padding(.top, 0)
                        .padding(.bottom, 30)
                }
                VStack{
                    Text("Solution x1")
                        .padding(.top)
                        .padding(.bottom, 0)
                    TextField("", text: $quadModel.x1Text)
                        .padding(.horizontal)
                        .frame(width: 100)
                        .padding(.top, 0)
                        .padding(.bottom,30)
                }
                VStack{
                    Text("Solution x2")
                        .padding(.top)
                        .padding(.bottom, 0)
                    TextField("", text: $quadModel.x2Text)
                        .padding(.horizontal)
                        .frame(width: 100)
                        .padding(.top, 0)
                        .padding(.bottom,30)
                }
                VStack{
                    Text("Solution x1'")
                        .padding(.top)
                        .padding(.bottom, 0)
                    TextField("", text: $quadModel.x1PrimeText)
                        .padding(.horizontal)
                        .frame(width: 100)
                        .padding(.top, 0)
                        .padding(.bottom,30)
                }
                VStack{
                    Text("Solution x2'")
                        .padding(.top)
                        .padding(.bottom, 0)
                    TextField("", text: $quadModel.x2PrimeText)
                        .padding(.horizontal)
                        .frame(width: 100)
                        .padding(.top, 0)
                        .padding(.bottom,30)
                }
            
            // Add calculate button that will run the calculations once pressed
            Button("Calculate", action: {Task.init {await solveQuadratic()}})
                    .padding(.top)
                    .padding(.top)
                    .padding(.bottom)
                    .padding()
                    .disabled(quadModel.enableButton == false)
            }
            HStack {
                VStack {
                    Text("Most precise solution for x1")
                        .padding(.top)
                        .padding(.bottom, 0)
                    TextField("", text: $quadModel.bestX1Text)
                        .padding(.horizontal)
                        .frame(width: 100)
                        .padding(.top, 0)
                        .padding(.bottom,30)
                }
                VStack {
                    Text("Most precise solution for x2")
                        .padding(.top)
                        .padding(.bottom, 0)
                    TextField("", text: $quadModel.bestX2Text)
                        .padding(.horizontal)
                        .frame(width: 100)
                        .padding(.top, 0)
                        .padding(.bottom,30)
                }
            }
        }
    }
    
    func solveQuadratic() async {
        quadModel.setButtonEnable(state: false)
        let _ : Bool = await quadModel.initWithValues(passedA: Double(aString)!, passedB: Double(bString)!, passedC: Double(cString)!)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
