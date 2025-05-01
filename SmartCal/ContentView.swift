//
//  ContentView.swift
//  SmartCal
//
//  Created by 方泽泉 on 2025/5/1.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State private var isWiggling = false
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showRegisterSheet = false

    var body: some View {
//        NavigationView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//                    } label: {
//                        Text(item.timestamp!, formatter: itemFormatter)
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//            Text("Select an item")
//        }
        ZStack {
            Image("BackImageLogin")
                .resizable()
                .ignoresSafeArea()
                
            VStack {
                
                Spacer()
                
                VStack(spacing: 20) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 60))
                        .symbolEffect(.wiggle, options: .repeat(.periodic()))
                        .foregroundColor(.accentColor)
                    
                    Text("Welcome to SmartCal!")
                        .font(.system(.title, design: .rounded))
                        .bold()
                    
                    Text("Please log in first.")
                        .font(.system(.headline, design: .rounded))
                    
                    // 账号输入框
                    TextField("Username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .autocapitalization(.none)
                        .keyboardType(.asciiCapable)
                    
                    // 密码输入框
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .keyboardType(.numberPad)
                    
                    // 登录按钮
                    Button(action: {
                        print("账号：\(username)，密码：\(password)")
                        // TODO: 在这里处理登录验证逻辑
                    }) {
                        Text("Confirm")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .font(.system(.headline, design: .rounded).weight(.bold))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                    .padding(.horizontal)
                    
                }
                .padding()
                .frame(width: 350, height: 400)
                .background(
                    VisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial)) // 这里设置毛玻璃效果
                        .cornerRadius(35.0)
                        .shadow(radius: 20.0)
                )
                .hideKeyboardOnTap()
                
                
                Spacer()
                Button(action: {
                    showRegisterSheet = true
                }) {
                    Text("Don't have an account yet?")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 20)
                .sheet(isPresented: $showRegisterSheet) {
                    RegisterView()
                }
            }
        }
        
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
//    return formatter
//}()

struct RegisterView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
//    @FetchRequest(
//        entity: UserInfo.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \UserInfo.password, ascending: false)],
//        animation: .default
//    )
//    var todoItems: FetchedResults<UserInfo>
    
    @State private var newUsername = ""
    @State private var newPassword = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("New Username", text: $newUsername)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .autocapitalization(.none)

                SecureField("New Password", text: $newPassword)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                Button("Register") {
                    print("注册账号：\(newUsername)，密码：\(newPassword)")
//                    let user = User(context: viewContext)
//                    user.username = newUsername
//                    user.password = newPassword
//                    do {
//                        try viewContext.save()
//                        dismiss()
//                    } catch {
//                        print("保存失败：\(error.localizedDescription)")
//                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)

                Spacer()
            }
            .padding()
            .navigationTitle("Register Account")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?

    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: effect)
        return view
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = effect
    }
}

// 实现自动释放键盘
extension View {
    func hideKeyboardOnTap() -> some View {
        self.onTapGesture {
            hideKeyboard()
        }
    }
}
func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
