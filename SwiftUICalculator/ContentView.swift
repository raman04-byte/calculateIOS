//
//  ContentView.swift
//  SwiftUICalculator
//
//  Created by Raman Tank on 30/10/24.
//

import SwiftUI

struct ContentView: View {
    
    let grid = [["AC","C","%","/"],
                ["7","8","9","X"],
                ["4","5","6","-"],
                ["1","2","3","+"],
                [".","0","","="]
    ]
    
    let operators = ["/","+","X","%"]
    
   @State var visisbleWorkings = ""
   @State var visibleResults = ""
   @State var showAlert = false
    
    var body: some View {
        VStack {
            HStack{
                Spacer()
                Text(visisbleWorkings).padding().foregroundColor(.white).font(.system(size: 30, weight: .heavy))
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            HStack{
                Spacer()
                Text(visibleResults).padding().foregroundColor(.white).font(.system(size: 50, weight: .heavy))
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
            ForEach(grid,id: \.self){
                row in
                HStack{
                    ForEach(row, id: \.self){
                        cell in
                        Button(action:{buttonPressed(cell: cell)}, label:{
                            Text(cell).foregroundColor(buttonColor(cell)).font(.system(size: 40, weight: .heavy)).frame(maxWidth: .infinity, maxHeight: .infinity)
                        })
                    }
                }
                
            }
        }
        .background(Color.black.ignoresSafeArea())
        .alert(isPresented: $showAlert){
            Alert(
                title: Text("Invalid Input"),
                message: Text(visisbleWorkings),
                dismissButton: .default(Text("Okay"))
            )
        }
    }
    
    func buttonColor(_ cell:String) -> Color{
        
        if(cell=="AC" || cell=="C"){
            return .red
        }
        
        if(cell=="-" || cell=="=" || operators.contains(cell)){
            return .orange
        }
        
        return .white
    }
    
    func buttonPressed(cell:String){
        switch (cell) {
        case "AC":
            visibleResults = ""
            visisbleWorkings = ""
        case "C":
            visisbleWorkings = String(visisbleWorkings.dropLast())
        case "=":
            visibleResults = calculateResults()
        case "-":
            addMinus()
        case "X","/","%","+":
            addOperator(cell)
        default:
            visisbleWorkings += cell
        }
    }
    
    func addOperator(_ cell: String) {
        if !visisbleWorkings.isEmpty{
            let last = String (visisbleWorkings.last!)
            if operators.contains(last) || last == "-"{
                visisbleWorkings.removeLast()
            }
            visisbleWorkings += cell
        }
    }
    
    func addMinus()  {
        if visisbleWorkings.isEmpty || visisbleWorkings.last != "-"
        {
            visisbleWorkings += "-"
        }
    }
    
    func calculateResults() -> String{
        
        
        if(validInput()){
            var workings = visisbleWorkings.replacingOccurrences(of: "%", with: "*0.01")
            workings = visisbleWorkings.replacingOccurrences(of: "X", with: "*")
            let expression = NSExpression(format: workings)
            let result = expression.expressionValue(with: nil, context: nil) as! Double
            return formatResult(val: result)
        }
        showAlert = true
        return ""
    }
    
    func validInput() -> Bool{
        if(visisbleWorkings.isEmpty){
            return false
        }
        
        let last = String(visisbleWorkings.last!)
        if(operators.contains(last) || last == "-"){
            if (last != "%" || visisbleWorkings.count == 1){
                return false
            }
        }
        
        return true
    }
    
    func formatResult(val: Double) -> String{
        if(val.truncatingRemainder(dividingBy: 1)==0){
            return String(format: "%.0f", val)
        }
        return String(format: "%.2f", val)
    }
    
}

#Preview {
    ContentView()
}
