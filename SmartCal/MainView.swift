//
//  MainView.swift
//  SmartCal
//
//  Created by 方泽泉 on 2025/5/1.
//

import SwiftUI

struct MainView: View {
    var user: Account_info

    var Hardlevel = [
        Level(name: "Grade one", image: "Grade1"),
        Level(name: "Grade two", image: "Grade2"),
        Level(name: "Grade three", image: "Grade3")
    ]
    var body: some View {
        
        VStack {
            NavigationStack{
                List {
                    ForEach(Hardlevel) { level in
                        NavigationLink(destination: GameView(level: level)){
                            BasicImageRow(Level: level)
                        }
                    }
                }
            }
            .navigationTitle("SmartCal")
            
            ScrollView(.vertical){
                VStack(alignment: .center){
                    
                }
            }
        }
    }
}

struct Level: Identifiable{
    var id = UUID()
    var name: String
    var image: String
}
struct BasicImageRow: View {
    var Level: Level
    
    var body: some View {
        HStack {
            Image(Level.image)
                .resizable()
                .frame(width: 40, height: 40)
                .cornerRadius(5)
            Text(Level.name)
        }
    }
}
