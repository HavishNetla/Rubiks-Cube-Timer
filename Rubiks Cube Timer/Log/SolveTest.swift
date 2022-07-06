//
//  Solve.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 7/21/21.
//

import SwiftUI

struct SolveTest: View {
    var time: Double
    var scramble: String
    var date: Date
    var puzzle: Puzzle
    var pb: Bool

    var body: some View {
        VStack {
            HStack {
                Text("\(formatDate())").padding(.trailing)
                    .font(.custom("asd", size: 10))
                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 0))
                Spacer()
                
                if (pb) {
                    PB()
                }
            }
            Text("\(time, specifier: "%.2f")")
                .font(.headline)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0))
            
        }
        .background(Color(.systemGray5))
        .cornerRadius(7)
    }
    
    func formatDate() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"

        return dateFormatterGet.string(from: date)
    }
}

struct PB: View {
    var body: some View {
        Text("PB")
            .font(.custom("asd", size: 10))
            .padding(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10))
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(3.0)
            .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 5))
    }
}


struct Solve_Previews: PreviewProvider {
    static var previews: some View {
        SolveTest(time: 24.52, scramble: "B2 R2 U2 F U2 F' R2 F' L2 B2 R2 B' U F' R' B F2 L B2 R B", date: Date.init(), puzzle: .threebythree, pb: true)
        
        PB()
    }
}
