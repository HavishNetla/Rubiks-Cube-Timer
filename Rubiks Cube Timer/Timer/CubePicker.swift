//
//  CubePicker.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 2/5/21.
//

import SwiftUI
import Neumorphic

let puzzles = ["2x2","3x3","4x4","5x5","6x6","7x7","Pyraminx","Megaminx","Skewb","Square 1"]
let sessions =  ["Default", "One Handed", "Roux"]

struct CubePicker: View {
    @Binding var puzzleSelection: Int
    @Binding var sessionSelection: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
            Text("Puzzle").bold().font(.system(.title, design: .rounded))
            Picker(selection: self.$puzzleSelection, label: Text("")) {
                ForEach(0 ..< puzzles.count) { index in
                    Text("\(puzzles[index])").tag(index)
                }
            }.frame(height: 100).clipped()
            
            Text("Session").bold().font(.system(.title, design: .rounded))
            Picker(selection: self.$sessionSelection, label: Text("")) {
                ForEach(0 ..< sessions.count) { index in
                    Text("\(sessions[index])").tag(index)
                }
            }.frame(height: 100).clipped()
        }).padding()
    }
}



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
        //.background(Color.black)
        .cornerRadius(2000.0)
        .background(RoundedRectangle(cornerRadius: 20)
                        .fill(Color(hex: 0x1A1B1E))
                        //.frame(width: 300, height: 180)
                        .shadow(color: Color(hex: 0x242529), radius: 8, x: -8, y: -8)
                        .shadow(color: Color(hex: 0x151518), radius: 8, x: 8, y: 8))
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

//struct CubePicker_Previews: PreviewProvider {
//    static var previews: some View {
//        HStack {
//            CubePicker()
//        }.frame(width: 400, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
//        
//        
//        CubePickerButton()
//        
//        RoundedRectangle(cornerRadius: 20)
//            .fill(Color.black)
//            .frame(width: 300, height: 180)
//            .shadow(color: Color(hex: 0x242529), radius: 8, x: -8, y: -8)
//            .shadow(color: Color(hex: 0x151518), radius: 8, x: 8, y: 8)
//    }
//}
