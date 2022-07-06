//
//  SolveMoreInfoView.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 7/22/21.
//

import SwiftUI

struct SolveMoreInfoView: View {
//    var time: Double?
//    var scramble: String?
//    var date: Date?
    var puzzle: Solve?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            HStack {
                Text("\(puzzle!.time, specifier: "%.2f")").font(.system(.largeTitle, design: .rounded)).bold()
                Spacer()
                VStack(alignment: .trailing, content: {
                    Text("\(formatDate())")
                    Text("\(formatTime())")
                })
                
            }
            // text.bubble
            Text("\(puzzle!.scramble!)").padding(.top)

            HStack {
                Image(systemName: "text.bubble").padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 7))
                Text("Comment text")
            }.padding(.top)
            
            Button(action: {}, label: {
                Label("Delete", systemImage: "trash")
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }).padding(.top)
        }).padding()
    }
    
    func formatDate() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"

        return dateFormatterGet.string(from: (puzzle?.timestamp!)!)
    }
    
    func formatTime() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "HH:mm:ss"

        return dateFormatterGet.string(from: (puzzle?.timestamp!)!)
    }
}
