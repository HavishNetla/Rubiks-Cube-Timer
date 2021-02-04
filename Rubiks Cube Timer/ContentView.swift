//
//  ContentView.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 2/1/21.
//

import SwiftUI

struct ContentView: View {
    @State var x = false
    
    var body: some View {
        VStack {
            TimerView()
                //.environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
