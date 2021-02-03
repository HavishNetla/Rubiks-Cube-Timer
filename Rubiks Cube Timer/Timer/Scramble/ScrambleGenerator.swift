//
//  ScrambleGenerator.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 2/3/21.
//

import Foundation

class ScrambleGenerator {
    enum Move {
        case front
        case right
        case up
        case left
        case back
        case down
    }
    let arr = [Move.front, Move.right, Move.up, Move.left, Move.back, Move.down]
    
    func generateScramble() -> [(Move, Int)] {
        // Generate 20 random moves
        var scramble: [(Move, Int)] = []
        for _ in 1...20 {
            scramble.append(generateRandomMove())
        }
        
        return scramble
    }
    
    func generateRandomMove() -> (Move, Int) {
        let randomMove = arr[Int.random(in: 0..<arr.count)]
        let randomCount = Int.random(in: 0...3)
        
        return (randomMove, randomCount)
    }
    
    func formatScramble(scramble: [(Move, Int)]) -> String {
        for move in scramble {
            var out = ""
            
            switch move.0 {
            case Move.front:
                out.append("F")
            case Move.right:
                out.append("R")
            case Move.up:
                out.append("U")
            case Move.left:
                out.append("L")
            case Move.back:
                out.append("B")
            case Move.down:
                out.append("D")
            default:
                out.append("Ops")
            }
            
            
        }
        
        
        return "penis"
    }
}
