//
//  3x3Visualizer.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 2/11/21.
//

import Foundation


class Visualizer3x3 {
    var scramble: String
    
    init(scramble: String) {
        self.scramble = scramble
    }
    
    private func parseScramble() {
        var parsed: [Move] = []
        
//        for instruction in scramble.components(separatedBy: "  ") {
//            let split = instruction.split(separator: Character(""))
//            parsed.append(Move(move: split[0], suffix: split[1]))
//        }
    }
}

struct Move {
    var move: Character
    var suffix: Character
}
