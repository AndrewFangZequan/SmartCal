//
//  GameView.swift
//  SmartCal
//
//  Created by 方泽泉 on 2025/5/1.
//

import SwiftUI

// 题目数据结构
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

struct GameView: View {
    let level: Level // 可用于后续扩展不同难度
    var user: Account_info
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var problems: [MathProblem]
    @State private var currentIndex: Int
    @State private var showResult = false
    @FocusState private var isInputFocused: Bool
    @State private var showIncompleteAlert = false
    @State private var isActive = true
    
    init(level: Level, user: Account_info) {
        self.level = level
        self.user = user
        _problems = State(initialValue: Self.generateProblems(for: level))
        _currentIndex = State(initialValue: 0)
    }
    
    var body: some View {
        ZStack{
            Image("colorbgi")
                .resizable()
                .ignoresSafeArea()
            content
                .onDisappear {
                    isActive = false
                }
        }
    }
    
    private var content: some View{
        VStack(spacing: 30) {
            // 进度指示
            ProgressView("\(currentIndex + 1)/30", value: Float(currentIndex + 1), total: 30)
                .padding(.horizontal)
                .frame(alignment: .top)
            
            // 题目展示
            Text(problems[currentIndex].question)
                .font(.system(size: 60, weight: .bold, design: .rounded))
            
            // 答案输入
            TextField("Answer", text: $problems[currentIndex].userAnswer)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .opacity(0.8)
                .frame(width: 150)
                .font(.system(size: 20, weight: .bold))
                .multilineTextAlignment(.center)
                .focused($isInputFocused)
                .onChange(of: problems[currentIndex].userAnswer) { _ , newValue in
                    validateAndProceed(newValue)
                }
            
            // 导航按钮
            HStack(spacing: 40) {
                Button(action: previousQuestion) {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.largeTitle)
                }
                .disabled(currentIndex == 0)
                
                Button(action: nextQuestion) {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.largeTitle)
                }
                .disabled(currentIndex == 29)
            }
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("Finish") {
                    isInputFocused = false // 收起键盘
                    
                    if currentIndex == 29 {
                        // 延迟0.3秒确保键盘收起动画完成
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            dismiss() // 返回上级视图
                        }
                    } else {
                        showIncompleteAlert = true // 显示未完成警告
                    }
                }
            }
        }
        // 添加新的警告弹窗
        .alert("Not Finished", isPresented: $showIncompleteAlert) {
            Button("Keep Answering", role: .cancel) {
                isInputFocused = true
            }
        } message: {
            Text("Please Press After Finish 30 Questions")
        }
    }
    
    // 自动生成30道题的方法
    private static func generateProblems(for level: Level) -> [MathProblem] {
        var problems = [MathProblem]()
        
        for _ in 0..<30 {
            let problem: MathProblem
            
            switch level.name {
            case "Grade one":
                problem = generateGradeOneProblem()
            case "Grade two":
                problem = generateGradeTwoProblem()
            case "Grade three":
                problem = generateGradeThreeProblem()
            default:
                problem = generateGradeOneProblem() // 默认回退
            }
            
            problems.append(problem)
        }
        
        return problems
    }

    private static func generateGradeOneProblem() -> MathProblem {
        let isAddition = Bool.random()
        let num1: Int
        let num2: Int
        
        if isAddition {
            num1 = Int.random(in: 0...10)
            num2 = Int.random(in: 0...(10 - num1))
        } else {
            num1 = Int.random(in: 1...10)
            num2 = Int.random(in: 0..<num1)
        }
        
        return MathProblem(
            num1: num1,
            num2: num2,
            operatorSymbol: isAddition ? "+" : "-",
            correctAnswer: isAddition ? num1 + num2 : num1 - num2
        )
    }

    private static func generateGradeTwoProblem() -> MathProblem {
        let isAddition = Bool.random()
        let num1: Int
        let num2: Int
        
        if isAddition {
            // 生成两位数加法（10-99）
            num1 = Int.random(in: 10...89)
            num2 = Int.random(in: 10...(99 - num1))
        } else {
            // 确保减法结果为正数
            num1 = Int.random(in: 11...99)
            num2 = Int.random(in: 10..<num1)
        }
        
        return MathProblem(
            num1: num1,
            num2: num2,
            operatorSymbol: isAddition ? "+" : "-",
            correctAnswer: isAddition ? num1 + num2 : num1 - num2
        )
    }

    private static func generateGradeThreeProblem() -> MathProblem {
        // 随机选择运算符（加减乘除）
        let operators = ["+", "-", "×", "÷"]
        let selectedOperator = operators.randomElement()!
        
        let num1: Int
        let num2: Int
        var answer: Int
        
        switch selectedOperator {
        case "+":
            num1 = Int.random(in: 0...100)
            num2 = Int.random(in: 0...(100 - num1))
            answer = num1 + num2
            
        case "-":
            num1 = Int.random(in: 0...100)
            num2 = Int.random(in: 0...num1)
            answer = num1 - num2
            
        case "×":
            // 保证乘积不超过100
            num1 = Int.random(in: 1...10)
            let maxMultiplier = min(100 / num1, 10)
            num2 = Int.random(in: 1...maxMultiplier)
            answer = num1 * num2
            
        case "÷":
            // 保证能整除
            let divisor = Int.random(in: 1...10)
            answer = Int.random(in: 1...10)
            num1 = divisor * answer
            num2 = divisor
            
        default:
            return generateGradeOneProblem()
        }
        
        return MathProblem(
            num1: num1,
            num2: num2,
            operatorSymbol: selectedOperator,
            correctAnswer: answer
        )
    }
    
    // 输入验证
    private func validateAndProceed(_ answer: String) {
        // 过滤非数字字符
        let filtered = answer.filter { $0.isNumber }
        
        // 限制最大输入长度（根据需求调整）
        let maxLength: Int
        switch level.name {
        case "Grade one": maxLength = 2  // 10以内题目最多2位
        case "Grade two": maxLength = 3  // 两位数加减法最多3位（如99+99=198）
        case "Grade three": maxLength = 4 // 乘法最多4位（如100×10=1000）
        default: maxLength = 4
        }
        
        problems[currentIndex].userAnswer = String(filtered.prefix(maxLength))
    }
    
    private func nextQuestion() {
        currentIndex = min(currentIndex + 1, 29)
        isInputFocused = true
    }
    
    private func previousQuestion() {
        currentIndex = max(currentIndex - 1, 0)
        isInputFocused = true
    }
}
