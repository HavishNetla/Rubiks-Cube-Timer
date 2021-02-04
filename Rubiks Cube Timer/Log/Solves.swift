//
//  Solves.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 2/3/21.
//

import SwiftUI

struct Solves: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Solve.timestamp, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Solve>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    SolveRow(time: item.time, scramble: item.scramble ?? "ops", date: item.timestamp!)

                }
                .onDelete(perform: deleteItems)                
            }
            .navigationBarTitle("Solves")
            .listStyle(GroupedListStyle())
            //.environment(\.horizontalSizeClass, .regular)

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
