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
let columns = [
    GridItem(.flexible(), spacing: 0),
    GridItem(.flexible(), spacing: 0),
    GridItem(.flexible(), spacing: 0),
    //GridItem(.flexible()),
]

struct CubePicker: View {
    @Binding var puzzleSelection: Int   
    @Binding var sessionSelection: Int
    
    var body: some View {
        VStack {
            Text("Select a puzzle").font(.title2).bold()
            LazyVGrid(columns: columns, spacing: 0, content: {
                ForEach(0..<puzzles.count, id: \.self) { item in
                    Button(action: {puzzleSelection = item}, label: {
                        VStack {
                            Image(puzzles[item].lowercased())
                                .resizable()
                                .frame(width: 35, height: 35)
                                
                            Text(puzzles[item]).bold()
                        }
                        //.padding()
                        //.background(puzzleSelection == item ? Color.init(hex: 0xabb3ff) : Color.black.opacity(0.0))
                    })
                    .frame(width: 90, height: 90)
                    .background(puzzleSelection == item ? Color.init(hex: 0xabb3ff).opacity(0.3) : Color.black.opacity(0.0))
                    .cornerRadius(10)
                }
            })
            .frame(width: 300)
        }
    }
}

struct CubePicker_Previews: PreviewProvider {
    @State static var puzzle: Int = 0
    @State static var session: Int = 1
    
    static var previews: some View {
        CubePicker(puzzleSelection: $puzzle, sessionSelection: $session)
    }
}
