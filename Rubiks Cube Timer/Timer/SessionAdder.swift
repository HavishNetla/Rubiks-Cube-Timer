//
//  SessionAdder.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 2/14/21.
//

import SwiftUI
import SPAlert

struct SessionAdder: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Session.timestamp, ascending: true)],
        animation: .default)
    private var sessions: FetchedResults<Session>
    
    @State private var name: String = ""
    @State private var puzzleIndex = 0

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
                Section(header: Text("Session information")) {
                    TextField("Session name", text: $name)
                    Picker(selection: $puzzleIndex, label: Text("Select a puzzle")) {
                        ForEach(0 ..< puzzles.count) {
                            Text(self.puzzles[$0])
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        var isValid = true
                        
                        if name == "" {
                            isValid = false
                            SPAlert.present(message: "Please enter a session name", haptic: .error)
                        } else {
                            for item in sessions {
                                if item.puzzle == Int32(puzzleIndex) && item.name == name {
                                    isValid = false
                                    
                                    // Present `SPAlert`
                                    SPAlert.present(message: "That session already exists", haptic: .error)
                                    
                                }
                            }
                        }
                        
                        if isValid {
                            // Create image from symbols
                            let image = UIImage.init(systemName: "checkmark")
                            // Create preset with custom image
                            let preset = SPAlertIconPreset.custom(image!)
                            // Present `SPAlert`
                            SPAlert.present(title: "Created Session", preset: preset)
                            
                            addSession()
                        }
                    }, label: {
                        Text("Submit").foregroundColor(.white).bold()
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                        
                    }).listRowBackground(Color.green)
                }
            }
            .navigationBarTitle("Add Session")
        }
    }
    
    private func addSession() {
        withAnimation {
            let newSession = Session(context: viewContext)
            newSession.name = name
            newSession.puzzle = Int32(puzzleIndex)
            newSession.timestamp = Date()
            
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

struct SessionAdder_Previews: PreviewProvider {
    static var previews: some View {
        SessionAdder()
    }
}
