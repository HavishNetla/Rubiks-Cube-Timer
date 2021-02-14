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
    @Binding var puzzleSelection: Int32
    
    var body: some View {
        VStack {
            List {
                ForEach(0..<puzzles.count, id: \.self) { item in
                    Button(action: {puzzleSelection = Int32(item)}, label: {
                        CubeRowView(puzzle: puzzles[item].lowercased(), display: puzzles[item], isSelected: puzzleSelection == item)
                    })
                    //.background(puzzleSelection == item ? Color.init(hex: 0xabb3ff).opacity(0.3) : Color.black.opacity(0.0))
                }
            }
        }
    }
}

struct CubeRowView: View {
    var puzzle: String
    var display: String
    var isSelected: Bool
    
    var body: some View {
        HStack {
            Image(puzzle)
                .resizable()
                .frame(width: 20, height: 20).padding(.trailing)
            
            Text(puzzle).foregroundColor(isSelected ? .blue : Color.primary)
        }
    }
}

struct CubePicker_Previews: PreviewProvider {
    @State static var puzzle: Int32 = 0

    
    static var previews: some View {
        CubePicker(puzzleSelection: $puzzle)
    }
}
