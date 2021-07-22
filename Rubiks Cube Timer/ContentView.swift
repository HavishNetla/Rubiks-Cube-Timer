//
//  ContentView.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 2/1/21.
//

import SwiftUI
import PartialSheet

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Solve.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Solve>
        
    
    @State var puzzleSelection = 0
    @State var sessionSelection: String = "Default"
    let defaults = UserDefaults.standard

    var body: some View {
        VStack {
            TabView {
                ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top), content: {
                    TimerView(puzzleSelection: $puzzleSelection, sessionSelection: $sessionSelection)
                        .addPartialSheet()
                })
                .tabItem {
                    Image(systemName: "timer")
                    Text("Timer")
                }
                Solves(puzzleSelection: $puzzleSelection, sessionSelection: $sessionSelection)
                    .addPartialSheet()
                    .tabItem {
                        Image(systemName: "folder")
                        Text("Solves")
                    }
                GraphView(puzzleSelection: $puzzleSelection, sessionSelection: $sessionSelection)
                    .addPartialSheet()
                    .tabItem {
                        Image(systemName: "chart.bar")
                        Text("Solves")
                    }
            }
        }.onAppear(perform: {
            let puzzle = defaults.integer(forKey: "Puzzle")
            let session = defaults.string(forKey: "Session")
            
            print(session)
            
            puzzleSelection = puzzle
            sessionSelection = session ?? "Default"
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
