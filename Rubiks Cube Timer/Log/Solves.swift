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
    
    
    @Binding var puzzleSelection: Int32
    @Binding var sessionSelection: String

    var body: some View {
        
        VStack {
            CubePickerButton(puzzleSelection: $puzzleSelection, sessionSelection: $sessionSelection).padding(.top)
            
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
    @State static var a = Int32(0)
    @State static var b = "sesision"
    
    static var previews: some View {
        Solves(puzzleSelection: $a, sessionSelection: $b).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
