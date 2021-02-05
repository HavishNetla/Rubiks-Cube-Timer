//
//  Scrambler.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 2/5/21.
//

import Foundation

class Scrambler {
    var moves: [String] // [F, B, L, R, U, D]
    var suffixes: [String] // [', 2]
    var len: Int
    
    init(moves: [String], suffixes: [String], len: Int) {
        self.moves = moves
        self.suffixes = suffixes
        self.suffixes.append("")
        
        self.len = len
    }
    
    func generateScramble() -> String {
        var scrambleArray: [String] = []
        
        // MARK: Pass 1, inset len number of moves
        for i in 0..<len {
            var move = moves.randomElement()
            
            if i != 0 {
                let prev = scrambleArray[i - 1]
                
                while prev == move {
                    move = moves.randomElement()
                }
            }
            
            scrambleArray.append(move!)
        }
        
        // MARK: Pass 2, insert suffixes
        for i in 0..<scrambleArray.count {
            var move: String = scrambleArray[i]
            move.append(suffixes.randomElement()!)
            
            scrambleArray[i] = move
        }
        
        return scrambleArray.joined(separator: "  ")
    }
}
