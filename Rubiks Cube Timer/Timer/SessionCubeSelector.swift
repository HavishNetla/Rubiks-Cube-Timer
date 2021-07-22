//
//  SessionSelector.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 2/10/21.
//

import SwiftUI
import CoreData

struct SessionCubeSelector: View {
    @Environment(\.managedObjectContext) private var viewContext
    let defaults = UserDefaults.standard

    @Binding var selectedPuzzle: Int
    @Binding var selectedSession: String

    @State private var isUsingDefault: Bool = true
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Session.timestamp, ascending: true)],
        animation: .default)
    var sessions: FetchedResults<Session>
    
    let puzzles = [
        "2x2",
        "3x3",
        "4x4",
        "5x5",
        "6x6",
        "7x7",
        "Megaminx",
        "Pyraminx",
        "Square 1",
        "Skewb"
    ]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Puzzle")) {
                    Picker(selection: $selectedPuzzle, label: Text("Select a puzzle")) {
                        ForEach(0 ..< puzzles.count) {
                            Text(self.puzzles[$0])
                        }
                    }
                }
                
                Section(header: Text("Session")) {
                    Toggle(isOn: $isUsingDefault) {
                        Text("Use the default session")
                    }.onChange(of: isUsingDefault, perform: { value in
                        if isUsingDefault {
                            selectedSession = "Default"
                        }
                    })
                    //
//                    Picker(selection: $selectedSession, label: /*@START_MENU_TOKEN@*/Text("Picker")/*@END_MENU_TOKEN@*/, content: {
//                        ForEach(sessions.filter {$0.puzzle == Int32(selectedPuzzle)}, id: \.self) { session in
//                            Text(session.name!).tag(session.name)
//                        }.onDelete(perform: deleteItems)
//                    })
                }
                
                Section {
                    if !(sessions.filter {$0.puzzle == Int32(selectedPuzzle)}.count == 0 || isUsingDefault) {
                        List {
                            ForEach(sessions.filter {$0.puzzle == Int32(selectedPuzzle)}, id: \.self) { session in
                                Button(action: {
                                    selectedSession = session.name!
                                }, label: {
                                    Text(session.name!)
                                        .foregroundColor(selectedSession == session.name! ? Color.green : Color.primary)
                                        .tag(session.name)
                                })
                            }.onDelete(perform: deleteItems)
                        }
                    }
                }
                
            }.navigationTitle("Puzzle/Session Selector")
            
          
        }.onAppear(perform: {
            if selectedSession != "Default" {
                isUsingDefault = false
            } else {
                isUsingDefault = true
            }
        })
        .onDisappear(perform: {
            print("got here", selectedSession)
            defaults.set("Session", forKey: "testing123")
            defaults.set("Puzzle", forKey: String(selectedPuzzle))
            
            print(defaults.string(forKey: "Session"))
        })
    }
    
    private func deleteItems(offsets: IndexSet) {
        //withAnimation {
        
        offsets.map { sessions[$0] }.forEach(viewContext.delete)

        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        // }
    }
    
    private func getFilteredItems(puzzle: Puzzle) -> FetchedResults<Session> {
        var sessionRequest: FetchRequest<Session>
        var items: FetchedResults<Session>{sessionRequest.wrappedValue}
        
        sessionRequest = FetchRequest(
            entity: Session.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Session.timestamp, ascending: true)],
            predicate: NSPredicate(format: "puzzle == %@", String(puzzle.rawValue))
        )
        
        return items
    }
    
    struct SessionSelector_Previews: PreviewProvider {
        @State static var a: String = "asd"
        @State static var b = 0

        static var previews: some View {
            SessionCubeSelector(selectedPuzzle: $b, selectedSession: $a)
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
