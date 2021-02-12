//
//  SessionSelector.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 2/10/21.
//

import SwiftUI

struct SessionSelector: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Session.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Session>
    
    var list = ["Default", "b", "c", "d"]
    var puzzle: Puzzle
    
    @State var selected = 0
    @State var showAlert = false
    
    @State var textString = ""
    
    
    var body: some View {
        ZStack {
            if self.showAlert {
                AlertControlView(textString: $textString,
                                 showAlert: $showAlert,
                                 title: "Enter new session name",
                                 message: "").onDisappear(perform: {
                                    addItem()
                                 })
            }
            
            VStack {
                HStack {
                    
                    Text("Select a session").font(.title2).bold()
                    Spacer()
                    Button(action: {
                        showAlert.toggle()
                    }, label: {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.blue)
                            .animation(.easeIn)
                        Text("Add new")
                    })
                }.padding()
                List{
                    ForEach(0..<items.count){ index in
                        HStack {
                            Button(action: {
                                selected = index
                            }) {
                                HStack{
                                    if selected == index {
                                        Image(systemName: "tag.fill")
                                            .foregroundColor(.blue)
                                            .animation(.easeIn)
                                            .padding(.trailing)
                                    } else {
                                        Image(systemName: "tag.fill")
                                            .foregroundColor(.gray)
                                            .animation(.easeIn)
                                            .padding(.trailing)
                                    }
                                    Text(items[index].name!).foregroundColor(.primary)
                                }
                            }.buttonStyle(BorderlessButtonStyle())
                        }
                    }
                }
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Session(context: viewContext)
            newItem.name = "testing123"
            newItem.puzzle = Int32(puzzle.rawValue)
            
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

struct SessionSelector_Previews: PreviewProvider {
    static var previews: some View {
        SessionSelector(puzzle: .threebythree)
    }
}
