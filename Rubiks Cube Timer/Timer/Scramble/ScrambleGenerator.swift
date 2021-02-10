//
//  Puzzles.swift
//  Rubiks Cube Timer
//
//  Created by Havish Netla on 2/5/21.
//

import Foundation

@objc enum Puzzle: Int32 {
    case twobytwo = 0
    case threebythree = 1
    case fourbyfour = 2
    case fivebyfive = 3
    case sixbysix = 4
    case sevenbyseven = 5
    case megaminx = 6
    case pyraminx = 7
    case square1 = 8
    case skewb = 9
}

struct ScrambleGenerator {
    func generateScramble(puzzle: Puzzle) -> String {
        switch puzzle {
        case .threebythree:
            let s = Scrambler(moves: ["F", "B", "L", "R", "U", "D"], suffixes: ["2", "'"], len: 15)
            
            return s.generateScramble()
        case .twobytwo:
            let s = Scrambler(moves: ["F", "B", "L", "R", "U", "D"], suffixes: ["2", "'"], len: 9)
            
            return s.generateScramble()
        case .fourbyfour:
            let s = Scrambler(moves: ["F", "B", "L", "R", "U", "D", "u", "d", "l", "r", "f", "b"], suffixes: ["2", "'"], len: 30)
            
            return s.generateScramble()
        case .fivebyfive:
            let s = Scrambler(moves: ["F", "B", "L", "R", "U", "D"], suffixes: ["2", "'"], len: 15)
            
            return s.generateScramble()
        case .sixbysix:
            let s = Scrambler(moves: ["F", "B", "L", "R", "U", "D"], suffixes: ["2", "'"], len: 15)
            
            return s.generateScramble()
        case .sevenbyseven:
            let s = Scrambler(moves: ["F", "B", "L", "R", "U", "D"], suffixes: ["2", "'"], len: 15)
            
            return s.generateScramble()
        case .megaminx:
            let s = Scrambler(moves: ["F", "B", "L", "R", "U", "D"], suffixes: ["2", "'"], len: 15)
            
            return s.generateScramble()
        case .pyraminx:
            let s = Scrambler(moves: ["U", "L", "R", "B", "u", "l", "r", "b"], suffixes: ["2", "'"], len: 15)
            
            return s.generateScramble()
        case .square1:
            let s = Scrambler(moves: ["F", "B", "L", "R", "U", "D"], suffixes: ["'"], len: 20)
            
            return s.generateScramble()
        case .skewb:
            let s = Scrambler(moves: ["F", "B", "L", "R", "U", "D"], suffixes: ["2", "'"], len: 15)
            
            return s.generateScramble()
        }
    }
}

