//
//  TimerManager.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 2/1/21.
//

import Foundation

class TimerManager: ObservableObject {
    @Published var elapsed = 0.00
    var timer = Timer()
    
    let precision = 3 // how many digits after the decimal

    func start() {
        elapsed = 0.00
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            self.elapsed += 0.01
        }
    }
    
    func reset() {
        elapsed = 0.0
    }
    
    func stop() {
        timer.invalidate()
    }
    
    func formatedTime() -> String {
        let len = String(elapsed).split(separator: ".")[1].count // len after decimal
        
        var string = String(elapsed)
        
        var numToRemove = 0
        if len - precision < 0 {
            numToRemove = 0
        } else {
            numToRemove = len - precision
        }
        string.removeLast(numToRemove)
        
        return string
    }
}

