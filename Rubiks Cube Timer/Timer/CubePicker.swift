//
//  CubePicker.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 2/5/21.
//

import SwiftUI

struct CubePicker: View {
    enum Cube: String, CaseIterable, Identifiable {
        case c3x3
        case c2x2
        
        var id: String { self.rawValue }
    }
    @State private var selectedCube = Cube.c3x3

    var body: some View {
        Picker("Cube", selection: $selectedCube) {
            Text("3x3").tag(Cube.c3x3)
            Text("2x2").tag(Cube.c2x2)
        }.pickerStyle(SegmentedPickerStyle())
    }
}

struct CubePicker_Previews: PreviewProvider {
    static var previews: some View {
        CubePicker()
    }
}
