//
//  CubePickerButton.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 2/10/21.
//

import SwiftUI
import SwiftEntryKit

struct CubePickerButton: View {
    var puzzle: Int
    var session: Int
    
    @State var a = false
    
    @State var puzzleSelection = 0
    @State var sessionSelection = 0
    
    let customView = UIView()
    
    var body: some View {
        HStack(alignment: .center, spacing: nil, content: {
            HStack {
                Button(action: {
                    print("Edit button was tapped")
                    a.toggle()
                }) {
                    Image(systemName: "gear").scaleEffect(1.25)
                }.sheet(isPresented: $a) {
                    NavigationView {
                        VStack {
                            CubePicker(puzzleSelection: $puzzleSelection, sessionSelection: $sessionSelection).padding(.top)
                            SessionSelector(puzzle: Puzzle.threebythree)
                        }
                        .navigationBarTitle(Text("Puzzle/Session Selector"), displayMode: .inline)
                        .navigationBarItems(trailing: Button(action: {
                            print("Dismissing sheet view...")
                            self.a = false
                        }) {
                            Text("Done").bold()
                        })
                    }
                }
                
                Spacer()
                VStack {
                    Text(puzzles[puzzle]).bold()
                    Text(sessions[session]).font(.caption).foregroundColor(Color.secondary)
                }
                Spacer()
                Button(action: {
                    SwiftEntryKit.display(entry: UIButton(), using: EKAttributes())
                }) {
                    Image(systemName: "square.on.circle").scaleEffect(1.25)
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
    static var previews: some View {
        CubePickerButton(puzzle: 0, session: 0)
    }
}

