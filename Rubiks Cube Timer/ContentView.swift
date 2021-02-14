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
        
    
    @State var puzzleSelection: Int32 = 0
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
            var hasAlreadyLaunched = defaults.bool(forKey: "hasAlreadyLaunched")
            
            if !hasAlreadyLaunched {
                addDefaultSession(puzzle: .twobytwo)
                addDefaultSession(puzzle: .threebythree)
                addDefaultSession(puzzle: .fourbyfour)
                addDefaultSession(puzzle: .fivebyfive)
                addDefaultSession(puzzle: .sixbysix)
                addDefaultSession(puzzle: .sevenbyseven)
                addDefaultSession(puzzle: .pyraminx)
                addDefaultSession(puzzle: .skewb)
                addDefaultSession(puzzle: .square1)
                
                defaults.set(true, forKey: "hasAlreadyLaunched")
            }
        })

    }
    
    private func addDefaultSession(puzzle: Puzzle) {
        withAnimation {
            let newItem = Session(context: viewContext)
            newItem.name = "Default"
            newItem.puzzle = Int32(puzzle.rawValue)
            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
