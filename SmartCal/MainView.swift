//
//  MainView.swift
//  SmartCal
//
//  Created by 方泽泉 on 2025/5/1.
//

import SwiftUI

//struct MainView: View {
//    var user: Account_info
//
//    var Hardlevel = [
//        Level(name: "Grade one", image: "Grade1"),
//        Level(name: "Grade two", image: "Grade2"),
//        Level(name: "Grade three", image: "Grade3")
//    ]
//    var body: some View {
//        
//        VStack {
//            NavigationStack{
//                List {
//                    ForEach(Hardlevel) { level in
//                        NavigationLink(destination: GameView(level: level, user: user)){
//                            BasicImageRow(Level: level)
//                        }
//                    }
//                }
//            }
//            .navigationTitle("SmartCal")
//            
//            ScrollView(.vertical){
//                VStack(alignment: .center){
//                    
//                }
//            }
//
//        }
//    }
//}
//
//struct Level: Identifiable{
//    var id = UUID()
//    var name: String
//    var image: String
//}
//struct BasicImageRow: View {
//    var Level: Level
//    
//    var body: some View {
//        HStack {
//            Image(Level.image)
//                .resizable()
//                .frame(width: 40, height: 40)
//                .cornerRadius(5)
//            Text(Level.name)
//        }
//    }
//}

struct MainView: View {
    var user: Account_info
    @State private var navigationPath = NavigationPath() // 使用导航路径管理
    
    let levels = [
        Level(name: "Grade one", image: "Grade1"),
        Level(name: "Grade two", image: "Grade2"),
        Level(name: "Grade three", image: "Grade3")
    ]
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            List(levels) { level in
                NavigationLink(value: level) { // 新版导航链接
                    BasicImageRow(level: level)
                }
            }
            .navigationTitle("SmartCal")
            .navigationDestination(for: Level.self) { level in
                GameView(level: level, user: user)
                    .onDisappear {
                        // 返回时自动重置路径（可选）
                        if navigationPath.count > 0 {
                            navigationPath.removeLast()
                        }
                    }
            }
        }
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
