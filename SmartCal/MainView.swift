//
//  MainView.swift
//  SmartCal
//
//  Created by 方泽泉 on 2025/5/1.
//

import SwiftUI

struct MainView: View {
    var user: Account_info
    @State private var navigationPath = NavigationPath() // 使用导航路径管理
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest private var batches: FetchedResults<Question>
    
    
    let levels = [
        Level(name: "Grade one", image: "Grade1"),
        Level(name: "Grade two", image: "Grade2"),
        Level(name: "Grade three", image: "Grade3")
    ]
    
    init(user: Account_info){
        self.user = user
        _batches = FetchRequest(
            entity: Question.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Question.time, ascending: false)],
            predicate: NSPredicate(format: "account == %@", user.uuid! as any CVarArg as CVarArg)
        )
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                Section("Choose difficulty level") {
                    ForEach(levels) { level in
                        NavigationLink(value: level) {
                            BasicImageRow(level: level)
                        }
                    }
                }
                
                Section("History") {
                    ForEach(groupedBatches, id: \.0) { batch, questions in
                        NavigationLink(value: batch) {
                            HistoryRow(
                                date: questions.first?.time ?? Date(),
                                correctCount: questions.filter { $0.ifright }.count,
                                totalCount: questions.count
                            )
                        }
                    }
                }
            }
            .navigationTitle("SmartCal")
            .navigationDestination(for: Level.self) { level in
                GameView(level: level, user: user)
            }
            .navigationDestination(for: UUID.self) { batchID in
                BatchDetailView(batchID: batchID, user: user)
            }
        }
    }
    private var groupedBatches: [(UUID, [Question])] {
        Dictionary(grouping: batches) { $0.batch! }
            .sorted { $0.value.first?.time ?? Date() > $1.value.first?.time ?? Date() }
            .map { ($0.key, $0.value) }
    }
}

struct HistoryRow: View {
    let date: Date
    let correctCount: Int
    let totalCount: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(date.formatted(date: .abbreviated, time: .shortened))
                .font(.headline)
            
            HStack {
                ProgressView(value: Double(correctCount), total: Double(totalCount))
                    .progressViewStyle(LinearProgressViewStyle())
                    .frame(width: 100)
                
                Spacer()
                
                Text("\(correctCount)/\(totalCount)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
//                Image(systemName: "chevron.right")
//                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
    }
}

struct BatchDetailView: View {
    let batchID: UUID
    let user: Account_info
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest var questions: FetchedResults<Question>
    
    // 获取批次元数据
    private var batchLevel: String {
        questions.first?.level ?? "Unknow"
    }
    
    private var batchDate: Date {
        questions.first?.time ?? Date()
    }

    init(batchID: UUID, user: Account_info) {
        self.batchID = batchID
        self.user = user
        _questions = FetchRequest(
            entity: Question.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Question.time, ascending: true)
            ],
            predicate: NSPredicate(format: "batch == %@ AND account == %@",
                                   batchID as CVarArg, user.uuid! as any CVarArg as CVarArg)
        )
    }
    
    var body: some View {
        List {
            // 头部信息
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    InfoRow(title: "Difficulty Level", value: batchLevel)
                    InfoRow(title: "Practicing Time", value: batchDate.formatted())
                }
                .padding(.vertical, 8)
            }
            
            // 题目列表
            Section("Questions") {
                ForEach(questions) { question in
                    HStack {
                        Text(question.question ?? "Unknow")
                            .foregroundColor(answerColor(for: question))
                        
                        Spacer()
                        
                        // 添加序号标签
                        Text("#\(questionNumber(for: question))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Practicing Details")
        .listStyle(.insetGrouped)
    }
    
    // 计算颜色逻辑
    private func answerColor(for question: Question) -> Color {
        guard let userAnswer = question.useranswer, !userAnswer.isEmpty else {
            return .orange // 未作答
        }
        
        return question.ifright ? .green : .red
    }
    
    // 计算题目序号
    private func questionNumber(for question: Question) -> Int {
        guard let index = questions.firstIndex(of: question) else { return 0 }
        return index + 1
    }
}

// 信息行组件
struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .font(.subheadline)
    }
}

// 确保 Level 遵循 Hashable 协议
struct Level: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var image: String
}

struct BasicImageRow: View {
    var level: Level
    
    var body: some View {
        HStack {
            Image(level.image)
                .resizable()
                .frame(width: 40, height: 40)
                .cornerRadius(5)
            Text(level.name)
        }
    }
}
