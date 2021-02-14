//
//  SessionSelector.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 2/10/21.
//

import SwiftUI
import CoreData

struct SessionSelector: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var puzzle: Puzzle
    
//        @FetchRequest(
//            sortDescriptors: [NSSortDescriptor(keyPath: \Session.timestamp, ascending: true)],
//            predicate: NSPredicate(format: "puzzle == %@", "0"),
//            animation: .default)
//        var items: FetchedResults<Session>
    //
    
    // var items : FetchedResults<Session>
    @State var textString = ""
    
    @Binding var selectedSession: String
    
    var sessionRequest: FetchRequest<Session>
    var items: FetchedResults<Session>{sessionRequest.wrappedValue}
    
    init(puzzle: Puzzle, selectedSession: Binding<String>) {
//        let request: NSFetchRequest<Session> = Session.fetchRequest()
//        request.predicate = NSPredicate(format: "puzzle == %@", "0")
//        request.sortDescriptors = [NSSortDescriptor(keyPath: \Session.timestamp, ascending: true)]
//        self.items = FetchRequest(fetchRequest: request).wrappedValue
        //        print(items)
        
        self.sessionRequest = FetchRequest(
            entity: Session.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Session.timestamp, ascending: true)],
            predicate: NSPredicate(format: "puzzle == %@", String(puzzle.rawValue))
        )
        
        print(sessionRequest)
        
        
        //let predicate = NSPredicate(format: "puzzle == %@", "0")
        
        //self.items = FetchRequest(entity: Session.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Session.timestamp, ascending: true)], predicate: predicate).wrappedValue
            
        self.puzzle = puzzle
        self._selectedSession = selectedSession
    }
    
    
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
                        var isValid = true
                        
//                        for i in items {
//                            if textString == i.name {
//                                isValid = false
//                                break
//                            }
//                        }
                        
                        if textString == "" {
                            isValid = false
                        }
                        
                        if isValid {
                            addItem()
                            refresh()
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
                ForEach(items, id: \.self) { item in
                    HStack {
                        Button(action: {
                            selectedSession = item.name!
                        }) {
                            HStack{
                                if selectedSession == item.name! {
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


                                Text(item.name!).foregroundColor(.primary)
                            }
                        }.buttonStyle(BorderlessButtonStyle())
                    }
                }.onDelete(perform: deleteItems)
                
            }
        }        
    }
   
    private func deleteItems(offsets: IndexSet) {
        //withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
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
    
    private func addItem() {
        withAnimation {
            let newItem = Session(context: viewContext)
            newItem.name = textString
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
    
    private func refresh() {
        //withAnimation {
            viewContext.refreshAllObjects()
        //}
    }
}

struct SessionSelector_Previews: PreviewProvider {
    @State static var a = "asd"
    static var previews: some View {
        SessionSelector(puzzle: .threebythree, selectedSession: $a)
    }
}
