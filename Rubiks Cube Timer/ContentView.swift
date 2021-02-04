//
//  ContentView.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 2/1/21.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Solve.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Solve>
    
    var body: some View {
        VStack {
            TabView {
                TimerView()
                    .tabItem {
                        Image(systemName: "timer")
                        Text("Timer")
                    }
                Solves()
                    .tabItem {
                        Image(systemName: "folder")
                        Text("Solves")
                    }
            }
        }
    }
    
    func average() -> String {
        if items.count == 0 {
            return "Average: -"
        }
        
        var average = 0.0
        
        for i in items {
            average += i.time
        }
        
        return "Average: \(String(average / Double(items.count)))"
    }
    
    func ao5() -> String {
        if items.count < 5 {
            return "Ao5: -"
        }
        
        var average = 0.0
        
        for i in 1...5 {
            average += items[i].time
        }
        
        return "Ao5: \(String(average / 5.0))"
    }
    
    func ao12() -> String {
        if items.count < 12 {
            return "Ao12: -"
        }
        
        var average = 0.0
        
        for i in 1...12 {
            average += items[i].time
        }
        
        return "Ao12: \(String(average / 12.0))"
    }
    
    func best() -> String {
        if items.count == 0 {
            return "Best: -"
        }
        
        return "Best: \(items.max())"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
