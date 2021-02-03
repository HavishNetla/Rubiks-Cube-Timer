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
}

