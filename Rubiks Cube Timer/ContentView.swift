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
            return "-"
        }
        
        var average = 0.0
        
        for i in items {
            average += i.time
        }
        
        return String(format: "%.2f", average / Double(items.count))
    }
    
    func ao5() -> String {
        if items.count < 5 {
            return "-"
        }
        
        var average = 0.0
        
        for i in 0..<5 {
            average += items[i].time
        }
        
        return String(format: "%.2f", average / 5.0)
    }
    
    func ao12() -> String {
        if items.count < 12 {
            return "-"
        }
        
        var average = 0.0
        
        for i in 1..<12 {
            average += items[i].time
        }
        
        return String(format: "%.2f", average / 12.0)
    }
    
    func best() -> String {
        if items.count == 0 {
            return "-"
        }
        
        var max = Double.infinity
        
        for i in items {
            if i.time < max {
                max = i.time
            }
        }
        
        return String(format: "%.2f", max)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
