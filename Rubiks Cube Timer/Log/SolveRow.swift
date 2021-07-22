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
    var puzzle: Puzzle
    var isPb: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
                HStack {
                    Text("\(time, specifier: "%.2f")")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    if (isPb) {
                        PB()
                    }
                    
                    
                    Spacer()
                    
                    Text("\(formatDate())").padding(.trailing)
                }.padding(EdgeInsets(top: 0, leading: 0, bottom: 2, trailing: 0))
                
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
    
    func enumToString(p: Puzzle) -> String {
        switch p {
        case .threebythree:
            return "3x3"
        case .twobytwo:
            return "2x2"
        case .fourbyfour:
            return "4x4"
        case .fivebyfive:
            return "5x5"
        case .sixbysix:
            return "6x6"
        case .sevenbyseven:
            return "7x7"
        case .megaminx:
            return "Megaminx"
        case .pyraminx:
            return "Pyraminx"
        case .square1:
            return "Square 1"
        case .skewb:
            return "Skewb"
        }
    }
}

struct SolveRow_Previews: PreviewProvider {
    static var previews: some View {
        SolveRow(time: 24.52, scramble: "B2 R2 U2 F U2 F' R2 F' L2 B2 R2 B' U F' R' B F2 L B2 R B", date: Date.init(), puzzle: .threebythree, isPb: true)
    }
}
