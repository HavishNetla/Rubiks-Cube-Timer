//
//  Solves.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 2/3/21.
//

import SwiftUI
import PartialSheet
import SPAlert

struct Solves: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Solve.timestamp, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Solve>
    
    @Binding var puzzleSelection: Int
    @Binding var sessionSelection: String
    @State private var pb: Double = Double.infinity
    @State private var showingConfirmationDeleteAlert = false
    
    let columns = [
        GridItem(.adaptive(minimum: 100, maximum: 120)),
    ]
    
    var body: some View {
        
        VStack {
            CubePickerButton(puzzleSelection: $puzzleSelection, sessionSelection: $sessionSelection)
                .padding(.top)
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        showingConfirmationDeleteAlert = true
                    }, label: {
                        Label("Delete All", systemImage: "trash")
                            .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    })
                    .alert(isPresented: $showingConfirmationDeleteAlert) {
                        Alert(
                            title: Text("Confirmation"),
                            message: Text("Are you sure you want to delete all your solves?"),
                            primaryButton: .destructive(Text("Yes")) {
                                for item in items.filter({$0.puzzle == Int32(puzzleSelection) && $0.session == sessionSelection}) {
                                    viewContext.delete(item)
                                }
                                
                                do {
                                    try viewContext.save()
                                } catch {
                                    // Replace this implementation with code to handle the error appropriately.
                                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                                    let nsError = error as NSError
                                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                                }
                                
                                let image = UIImage.init(systemName: "trash")
                                let preset = SPAlertIconPreset.custom(image!)
                                SPAlert.present(title: "Deleted all solves", preset: preset)
                            },
                            secondaryButton: .default(Text("No"))
                        )
                    }
                    
                    
                }
            }
            
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(items.filter {$0.puzzle == Int32(puzzleSelection) && $0.session == sessionSelection}, id: \.self) { item in
                        SolveTest(time: item.time, scramble: item.scramble ?? "ops", date: item.timestamp!, puzzle: Puzzle(rawValue: item.puzzle)!, pb: item.time == pb).tag(item.timestamp)
                            .contextMenu(ContextMenu(menuItems: {
                                Button {
                                    print("Delete")
                                    viewContext.delete(item)
                                    
                                    do {
                                        try viewContext.save()
                                    } catch {
                                        // Replace this implementation with code to handle the error appropriately.
                                        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                                        let nsError = error as NSError
                                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                                    }
                                    
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                
                                Button {
                                    print("Share")
                                } label: {
                                    Label("Share", systemImage: "square.and.arrow.up")
                                }
                            }))
                    }
                }
                .padding(.horizontal)
            }.padding(.vertical)
        }.onChange(of: puzzleSelection, perform: { value in
            findPB()
        })
        .onChange(of: sessionSelection, perform: { value in
            findPB()
        })
        .onAppear(perform: {
            findPB()
        })
    }
    
    private func findPB() {
        pb = Double.infinity
        for item in items.filter({$0.puzzle == Int32(puzzleSelection) && $0.session == sessionSelection}) {
            if (item.puzzle == Int32(puzzleSelection) && item.session == sessionSelection) {
                if (pb > item.time) {
                    self.pb = item.time
                }
            }
        }
        print("PB is \(pb)")
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
        findPB()
    }
    
    private func getFilteredItems(puzzle: Int32, session: String) -> FetchedResults<Solve > {
        //print(items)
        var solveRequest: FetchRequest<Solve>
        var items: FetchedResults<Solve>{solveRequest.wrappedValue}
        
        solveRequest = FetchRequest(
            entity: Solve.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Solve.timestamp, ascending: false)]
            //predicate: NSPredicate(format: "puzzle == 1", String(puzzle), session)
        )
        
        //print(items)
        return items
    }
}

struct Solves_Previews: PreviewProvider {
    @State static var a = 0
    @State static var b: String = "sesision"
    
    static var previews: some View {
        //        Solves(puzzleSelection: $a, sessionSelection: $b).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        
        
        Button(action: {}, label: {
            Label("Delete All", systemImage: "trash")
                .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
        })
    }
}
