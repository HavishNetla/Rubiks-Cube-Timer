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
    
    @State var puzzleSelection: Int = 0
    @State var sessionSelection: Int = 0
    @State var showSelector = false

    var body: some View {
        let data: [Double] = items.reversed().map { $0.time }
        
        VStack {
            Button(action: {
                self.partialSheetManager.showPartialSheet({
                    print("Partial sheet dismissed", puzzleSelection)
                }) {
                    CubePicker(puzzleSelection: $puzzleSelection, sessionSelection: $sessionSelection)
                }
            }, label: {
                CubePickerButton(puzzle: Int(puzzleSelection), session: sessionSelection).padding(.bottom)
            }).padding(EdgeInsets(top: 40, leading: 0, bottom: 0, trailing: 0 ))

            
            LineView(data: data, title: "Line chart", legend: "Full screen")            //.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center, height: 1000)
                //.frame(height: 500)
                .padding()
                .padding(.top)
        }.present(isPresented: $showSelector, type: .alert, position: .top, autohideDuration: Double.infinity, closeOnTapOutside: true) {
            CubePicker(puzzleSelection: $puzzleSelection, sessionSelection: $sessionSelection)
        }

        // legend is optional, use optional .padding()

    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
