//
//  CubePickerButton.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 2/10/21.
//

import SwiftUI

struct CubePickerButton: View {
    var puzzle: Int
    var session: Int
    
    var body: some View {
        HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
            Text("Puzzle: ").bold().foregroundColor(.white) +
                Text(puzzles[puzzle]).foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            
            Text("Session: ").bold().foregroundColor(.white) +
                Text(sessions[session]).foregroundColor(.orange)
        })
        .padding(EdgeInsets(top: 10, leading: 40, bottom: 10, trailing: 40))
        .cornerRadius(2000.0)
        .overlay(
            RoundedRectangle(cornerRadius: 2000)
                .stroke(Color.gray, lineWidth: 1)
        )
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

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
