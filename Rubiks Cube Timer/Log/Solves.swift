//
//  Solves.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 2/3/21.
//

import SwiftUI
import PartialSheet

struct Solves: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Solve.timestamp, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Solve>
    
    
    @State var puzzle: Int = 0
    @State var session: Int = 0
    
    var body: some View {
        
        VStack {
            Button(action: {
                self.partialSheetManager.showPartialSheet({
                    print("Partial sheet dismissed", puzzle)
                }) {
                    CubePicker(puzzleSelection: $puzzle)
                }
            }, label: {
                CubePickerButton(puzzle: Int(puzzle), session: session).padding(.bottom)
            }).padding(EdgeInsets(top: 40, leading: 0, bottom: 0, trailing: 0 ))
            
            List {
                ForEach(items) { item in
                    SolveRow(time: item.time, scramble: item.scramble ?? "ops", date: item.timestamp!, puzzle: Puzzle(rawValue: item.puzzle)!)
                }
                .onDelete(perform: deleteItems)
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
}

struct Solves_Previews: PreviewProvider {
    static var previews: some View {
        Solves().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
