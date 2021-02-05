//
//  ScrambleGenerator.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 2/3/21.
//

import Foundation

class ScrambleGenerator {
    enum Move: String {
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
        for i in 0...20 {
            var curr = generateRandomMove()
            
            if i != 0 {
                let prev = scramble[i - 1]
                curr = generateRandomMove()
                
                while true {
                    if prev.0.rawValue != curr.0.rawValue {
                        break
                    }
                    print(prev.0.rawValue)
                    curr = generateRandomMove()
                }
            }
            scramble.append(curr)
        }
        
        
        // Make sure two adjacent scrambles do not have the same move
        for (i, move) in scramble.enumerated() {
            if i != scramble.count - 1 {
                if scramble[i + 1].0 == move.0 {
                    var newMove = generateRandomMove()
                    
                    while scramble[i].0 == newMove.0 {
                        newMove = generateRandomMove()
                    }
                    
                    scramble[i] = newMove
                }
            }
        }
        
        return scramble
    }

    func isValidNext(a: Move, b: Move) -> Bool {
        if a.rawValue == b.rawValue {
            return false
        } else {
            return true
        }
    }
    
    func generateRandomMove() -> (Move, Int) {
        let randomMove = arr[Int.random(in: 0..<arr.count)]
        let randomCount = Int.random(in: 1...3)
        
        return (randomMove, randomCount)
    }
    
    func formatScramble(scramble: [(Move, Int)]) -> String {
        var formatted = ""
        for move in scramble {
            formatted.append(formatMove(move: move))
        }
        
        return formatted
    }
    
    func formatMove(move: (Move, Int)) -> String {
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
        }
        
        if move.1 != 0 {
            if move.1 == 3 {
                out.append("\'")
            } else if move.1 == 2 {
                out.append("2")
            }
        }
        out.append("  ")
        
        return out
    }
}
