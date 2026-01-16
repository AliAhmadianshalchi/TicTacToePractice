//
//  ContentView.swift
//  TicTacToePractice
//
//  Created by Ali Ahmadian on 8/01/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: ViewModel = ViewModel()
    
    var body: some View {
        LazyVGrid(columns: viewModel.columns) {
            ForEach(0..<9) { i in
                ZStack {
                    Circle()
                        .foregroundColor(.cyan).opacity(0.3)
                    Image(systemName: viewModel.moves[i]?.indicator ?? "")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(.white)
                }
                .onTapGesture {
                    viewModel.onButtonTapped(index: i)
                }
            }
            .disabled(viewModel.isGameboardDisabled)
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(title: alertItem.title,
                      message: alertItem.message,
                      dismissButton: .default(alertItem.title,
                                              action: { viewModel.resetGame() }))
            }
        }
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
