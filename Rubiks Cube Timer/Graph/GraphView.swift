//
//  GraphView.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 2/10/21.
//

import SwiftUI
import SwiftUICharts
import PartialSheet

struct GraphView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var partialSheetManager: PartialSheetManager

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Solve.timestamp, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Solve>
    
    @Binding var puzzleSelection: Int
    @Binding var sessionSelection: String?

    var body: some View {
        let data: [Double] = items.reversed().map { $0.time }
        
        VStack {
            CubePickerButton(puzzleSelection: $puzzleSelection, sessionSelection: $sessionSelection).padding(.top)

            
            LineView(data: data, title: "Line chart", legend: "Full screen")            //.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center, height: 1000)
                //.frame(height: 500)
                .padding()
                .padding(.top)
        }

    }
}

struct GraphView_Previews: PreviewProvider {
    @State static var a = 0
    @State static var b: String? = "session"
    
    static var previews: some View {
        GraphView(puzzleSelection: $a, sessionSelection: $b).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
