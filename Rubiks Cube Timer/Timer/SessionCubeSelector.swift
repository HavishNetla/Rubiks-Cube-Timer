//
//  SessionSelector.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 2/10/21.
//

import SwiftUI
import CoreData
import SPAlert

struct SessionCubeSelector: View {
    @Environment(\.managedObjectContext) private var viewContext
    let defaults = UserDefaults.standard

    @Binding var selectedPuzzle: Int
    @Binding var selectedSession: String

    @State private var isUsingDefault: Bool = true
    @State private var showingConfirmationDeleteAlert = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Session.timestamp, ascending: true)],
        animation: .default)
    var sessions: FetchedResults<Session>
    
    @State private var sessionToDelete: Session?

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Solve.timestamp, ascending: false)],
        animation: .default)
    private var solves: FetchedResults<Solve>
    
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
                    }.onChange(of: selectedPuzzle, perform: { value in
                        if sessions.filter({$0.puzzle == Int32(selectedPuzzle)}).isEmpty {
                            isUsingDefault = true
                            selectedSession = "Default"
                        }
                    })
                }
                
                Section(header: Text("Session")) {
                    Toggle(isOn: $isUsingDefault) {
                        Text("Use the default session")
                    }.onChange(of: isUsingDefault, perform: { value in
                        if sessions.filter({$0.puzzle == Int32(selectedPuzzle)}).isEmpty && isUsingDefault == false {
                            let image = UIImage.init(systemName: "nosign")
                            let preset = SPAlertIconPreset.custom(image!)
                            SPAlert.present(title: "No avalible sessions. Please create one in the \"Add Session\" tab", preset: preset)
                            
                            isUsingDefault = true
                            selectedSession = "Default"
                        } else {
                            if isUsingDefault {
                                selectedSession = "Default"
                            } else {
                                selectedSession = sessions.filter {$0.puzzle == Int32(selectedPuzzle)}[0].name ?? "Default"
                            }
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
                                    HStack {
                                        Text(session.name!)
                                            .foregroundColor(selectedSession == session.name! ? Color.green : Color.primary)
                                            .tag(session.name)
                                            .contextMenu(ContextMenu(menuItems: {
                                                Button {
                                                    showingConfirmationDeleteAlert = true
                                                    sessionToDelete = session
                                                } label: {
                                                    Label("Delete", systemImage: "trash.fill")
                                                }
                                            }))
                                        Spacer()
                                        
                                        Button(action: {
                                            showingConfirmationDeleteAlert = true
                                            sessionToDelete = session
                                        }) {
                                            Image(systemName: "trash.fill").foregroundColor(.red)
                                        }
                                    }
                                })
                                .alert(isPresented: $showingConfirmationDeleteAlert) {
                                    Alert(
                                        title: Text("Confirmation"),
                                        message: Text("Are you sure you want to delete this session and ALL the solves in the session?"),
                                        primaryButton: .destructive(Text("Yes")) {
                                            withAnimation {

                                                let sessionToDeleteTemp = sessionToDelete!.name
                                                
                                                viewContext.delete(sessionToDelete!)
                                                
                                                for solve in solves.filter({$0.puzzle == Int32(selectedPuzzle) && $0.session == sessionToDeleteTemp}) {
                                                    viewContext.delete(solve)
                                                }
                                                
                                                do {
                                                    try viewContext.save()
                                                } catch {
                                                    // Replace this implementation with code to handle the error appropriately.
                                                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                                                    let nsError = error as NSError
                                                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                                                }
                                                
                                                if selectedSession == sessionToDeleteTemp {
                                                    selectedSession = sessions.filter {$0.puzzle == Int32(selectedPuzzle)}[0].name ?? "Default"
                                                }
                                                
                                                let image = UIImage.init(systemName: "trash")
                                                let preset = SPAlertIconPreset.custom(image!)
                                                SPAlert.present(title: "Deleted the session, and all the solves in the session", preset: preset)
                                                
                                            }
                                        },
                                        secondaryButton: .default(Text("No"))
                                    )
                                }
                            }//.onDelete(perform: deleteItems)
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
