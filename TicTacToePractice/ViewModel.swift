//
//  ViewModel.swift
//  TicTacToePractice
//
//  Created by Ali Ahmadian on 16/01/26.
//

import SwiftUI
import Combine

final class ViewModel: ObservableObject {
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameboardDisabled: Bool = false
    @Published var alertItem: AlertItem?
    
    func onButtonTapped(index: Int) {
        if isSquareOccupied(in: moves, forIndex: index) { return }
        moves[index] = Move(player: .human, boardIndex: index)
        
        // check for win condition
        if checkWinCondition(for: .human, in: moves) {
            alertItem = AlertContext.humanWin
            return
        }
        
        // check for Draw condition
        if checkForDrawCondition(in: moves) {
            alertItem = AlertContext.draw
            return
        }
        
        isGameboardDisabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let computerPosition = self.determineComputeMovePosition(in: self.moves)
            self.moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            
            self.isGameboardDisabled = false
            // check for win condition
            if self.checkWinCondition(for: .computer, in: self.moves) {
                self.alertItem = AlertContext.computerWin
                return
            }
        }
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        // use of closures which is a function that can be passed around.
        // for each individual element in the array
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    func determineComputeMovePosition(in moves: [Move?]) -> Int {
        // If AI can win, then win
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        let computerMoves = moves.compactMap { $0 }.filter({ $0.player == .computer })
        let computerPositions = Set(computerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositios = pattern.subtracting(computerPositions)
            
            if winPositios.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositios.first!)
                if isAvailable { return winPositios.first! }
            }
        }
        
        // IF AI can't win, then block
        let humanMoves = moves.compactMap { $0 }.filter({ $0.player == .human })
        let humanPositions = Set(humanMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositios = pattern.subtracting(humanPositions)
            
            if winPositios.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositios.first!)
                if isAvailable { return winPositios.first! }
            }
        }
        // if AI can't block, then take middle square
        let centerSquare = 4
        if !isSquareOccupied(in: moves, forIndex: centerSquare) {
            return centerSquare
        }
        
        // If AI can't take middle square, take random available square
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        // compactMap removes all the nils and just returns moves.
        // filters all the human or computer moves here.
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        // go to all the player moves and give me all the boardIndexes.
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for winPattern in winPatterns where winPattern.isSubset(of: playerPositions) {
            return true
        }
        
        return false
    }
    
    func checkForDrawCondition(in moves: [Move?]) -> Bool {
        // run compactMap to remove all the nils
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
}
