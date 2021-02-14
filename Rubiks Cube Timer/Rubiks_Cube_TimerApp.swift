//
//  Rubiks_Cube_TimerApp.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 2/1/21.
//

import SwiftUI
import PartialSheet

@main
struct Rubiks_Cube_TimerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            let sheetManager: PartialSheetManager = PartialSheetManager()
            
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(sheetManager)
        }
    }
}
