//
//  ContentView.swift
//  TicTacToePractice
//
//  Created by Ali Ahmadian on 8/01/26.
//

import SwiftUI

struct ContentView: View {
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isGameboardDisabled: Bool = false
    @State private var alertItem: AlertItem?
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(0..<9) { i in
                ZStack {
                    Circle()
                        .foregroundColor(.cyan).opacity(0.3)
                    Image(systemName: moves[i]?.indicator ?? "")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(.white)
                }
                .onTapGesture {
                    if isSquareOccupied(in: moves, forIndex: i) { return }
                    moves[i] = Move(player: .human, boardIndex: i)
                    
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
                        let computerPosition = determineComputeMovePosition(in: moves)
                        moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                        
                        isGameboardDisabled = false
                        // check for win condition
                        if checkWinCondition(for: .computer, in: moves) {
                            alertItem = AlertContext.computerWin
                            return
                        }
                    }
                }
            }
            .disabled(isGameboardDisabled)
            .alert(item: $alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.title,
                                              action: { resetGame() }))
            }
        }
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        // use of closures which is a function that can be passed around.
        // for each individual element in the array
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    func determineComputeMovePosition(in moves: [Move?]) -> Int {
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

enum Player {
    case human
    case computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}

#Preview {
    ContentView()
}
