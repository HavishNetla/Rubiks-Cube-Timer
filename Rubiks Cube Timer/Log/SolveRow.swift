//
//  Solve.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 2/3/21.
//

import SwiftUI

struct SolveRow: View {
    var time: Double
    var scramble: String
    var date: Date
        
    var body: some View {
        HStack {
            Image("3x3")
                .resizable()
                .frame(width: 30, height: 30)
                .padding(.trailing)
                .padding(.leading)
            
            
            VStack(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                HStack {
                    Text("\(time, specifier: "%.2f")")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Text("\(formatDate())").padding(.trailing)
                }
                
                Text("\(scramble)")
                    .font(.footnote)
                    .foregroundColor(Color.gray)
            })
            
        }
    }
    
    func formatDate() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"

        return dateFormatterGet.string(from: date)
    }
}

struct SolveRow_Previews: PreviewProvider {
    static var previews: some View {
        SolveRow(time: 24.52, scramble: "B2 R2 U2 F U2 F' R2 F' L2 B2 R2 B' U F' R' B F2 L B2 R B", date: Date.init())
    }
}
