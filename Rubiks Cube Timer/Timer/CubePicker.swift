//
//  CubePicker.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 2/5/21.
//

import SwiftUI

struct CubePicker: View {
    @State var hourSelection = 0
    @State var minuteSelection = 0
    @State var secondSelection = 0
    
    var puzzles = ["2x2","3x3","4x4","5x5","6x6","7x7","Pyraminx","Megaminx","Skewb","Square 1"]
    var sessions =  ["Default", "One Handed", "Roux"]
    
    var body: some View {
        //        GeometryReader { geometry in
        VStack(alignment: .leading, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
            Text("Cube").bold().font(.system(.title, design: .rounded))
            Picker(selection: self.$hourSelection, label: Text("")) {
                ForEach(0 ..< self.puzzles.count) { index in
                    Text("\(self.puzzles[index])").tag(index)
                }
            }.frame(height: 100).clipped()
            //                .frame(width: geometry.size.width/3)
            //                .clipped()
            //
            Text("Session").bold().font(.system(.title, design: .rounded))
            Picker(selection: self.$minuteSelection, label: Text("")) {
                ForEach(0 ..< self.sessions.count) { index in
                    Text("\(self.sessions[index])").tag(index)
                }
            }.frame(height: 100).clipped()
            //                .frame(width: geometry.size.width*2/3)
            //                .clipped()
            //            }.frame(height: 200)
            //            .clipped()
        }).padding()
    }
}
struct CubePicker_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            CubePicker()
        }.frame(width: 400, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
    }
}
