//
//  CubePickerButton.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 2/10/21.
//

import SwiftUI
import SwiftEntryKit

struct CubePickerButton: View {
    let puzzles = ["2x2","3x3","4x4","5x5","6x6","7x7","Pyraminx","Megaminx","Skewb","Square 1"]

    @State var puzzleSheet = false
    @State var sessionAdderSheet = false

    @Binding var puzzleSelection: Int
    @Binding var sessionSelection: String?

    let customView = UIView()
    
    var body: some View {
        HStack(alignment: .center, spacing: nil, content: {
            HStack {
                Button(action: {
                    print("Edit button was tapped")
                }) {
                    Image(systemName: "gear").scaleEffect(1.25)
                }
                
                Spacer()
                Button(action: {
                    puzzleSheet.toggle()
                }, label: {
                    VStack {
                        Text(puzzles[Int(puzzleSelection)]).bold().foregroundColor(Color.primary)
                        Text(sessionSelection ?? "ops").font(.caption).foregroundColor(Color.secondary)
                    }
                }).sheet(isPresented: $puzzleSheet) {
                    VStack {
                        SessionCubeSelector(selectedPuzzle: $puzzleSelection, selectedSession: $sessionSelection)
                    }
                    .navigationBarItems(trailing: Button(action: {
                        print("Dismissing sheet view...")
                        self.puzzleSheet = false
                    }) {
                        Text("Done").bold()
                    })
                    
                }
                
                Spacer()
                Button(action: {
                    sessionAdderSheet.toggle()
                }) {
                    Image(systemName: "square.on.circle").scaleEffect(1.25)
                }.sheet(isPresented: $sessionAdderSheet) {
                    SessionAdder()
                }
            }
        })
        .padding(EdgeInsets(top: 10, leading: 25, bottom: 10, trailing: 25))
        .cornerRadius(12.0)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray, lineWidth: 1)
        ).onAppear(perform: {
            
        })
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

struct CubePickerButton_Previews: PreviewProvider {
    @State static var a = 1
    @State static var b: String? = "asd"

    static var previews: some View {
        CubePickerButton(puzzleSelection: $a, sessionSelection: $b)
    }
}

