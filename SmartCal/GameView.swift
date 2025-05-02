//
//  GameView.swift
//  SmartCal
//
//  Created by 方泽泉 on 2025/5/1.
//

import SwiftUI

struct GameView: View {
    var level: Level
    
    var body: some View {
        
    }
}

//题目的数据结构
struct MathProblem {
    let num1: Int
    let num2: Int
    let operatorSymbol: String
    let correctAnswer: Int
    var userAnswer: String = ""
    
    var question: String {
        "\(num1) \(operatorSymbol) \(num2) = ?"
    }
}
