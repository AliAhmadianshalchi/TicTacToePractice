//
//  Alerts.swift
//  TicTacToePractice
//
//  Created by Ali Ahmadian on 8/01/26.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonText: Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You Win!"),
                             message: Text("Congratulations!"),
                             buttonText: Text("Play Again"))
    
    static let computerWin = AlertItem(title: Text("Computer Wins!"),
                                message: Text("Better luck next time."),
                                buttonText: Text("Play Again"))
    
    static let draw = AlertItem(title: Text("Draw!"),
                                message: Text("Better luck next time."),
                                buttonText: Text("Play Again"))
}
