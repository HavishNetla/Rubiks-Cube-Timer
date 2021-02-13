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
    var items: FetchedResults<Session>
    
    var puzzle: Puzzle
    @State var selected = -1
    @State var selectedText = ""
    
    @State var textString = ""
    
    @Binding var selectedSession: String
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Select a session").font(.title2).bold()
                    Spacer()
                }
                
                HStack {
                    TextField("Enter session name", text: $textString)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Button(action: {
                        if textString != "" {
                            addItem()
                        }
                    }, label: {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.blue)
                            .animation(.easeIn)
                        Text("Add new")
                    })
                }
            }.padding()
            
            List{
                ForEach(-1..<items.count, id: \.self){ index in
                    HStack {
                        Button(action: {
                            selected = index
                            if index == -1 {
                                selectedSession = "Default"
                            } else {
                                selectedSession = items[index].name!
                            }
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
                                
                                if index == -1 {
                                    Text("Default").foregroundColor(.primary)
                                } else {
                                    Text(items[index].name!).foregroundColor(.primary)
                                }
                            }
                        }.buttonStyle(BorderlessButtonStyle())
                    }
                }.onDelete(perform: deleteItems)
            }
        }        
    }
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
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
    
    private func addItem() {
        withAnimation {
            let newItem = Session(context: viewContext)
            newItem.name = textString
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
    
    private func refresh() {
        withAnimation {
            viewContext.refreshAllObjects()
        }
    }
}

struct SessionSelector_Previews: PreviewProvider {
    @State static var a = "asd"
    static var previews: some View {
        SessionSelector(puzzle: .threebythree, selectedSession: $a)
    }
}
