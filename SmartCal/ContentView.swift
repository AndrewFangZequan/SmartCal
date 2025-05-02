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
    
    @FetchRequest(
        entity: Account_info.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Account_info.uuid, ascending: false)]
    )
    var account_info: FetchedResults<Account_info>
    
    @State private var isWiggling = false
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var alertMessage: String = ""
    @State private var showRegisterSheet = false
    @State private var showAlert = false
    
    @State private var isLoggedIn = false
    @State private var loggedInUser: Account_info?

    var body: some View {
        NavigationStack {
            if isLoggedIn, let user = loggedInUser{
                MainView(user: user)
            } else {
                loginContentView
            }
        }
    }
    
    private var loginContentView: some View{
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
                    Button(action: handleLogin) {
                        Text("Confirm")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .font(.system(.headline, design: .rounded).weight(.bold))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                    .alert(alertMessage, isPresented: $showAlert){
                        Button("OK", role: .cancel){}
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
    private func handleLogin() {
        guard !username.isEmpty, !password.isEmpty else {
            showAlert(message: "Username and Password can't be empty!")
            return
        }
        
        if let account = account_info.first(where: {
            $0.username == username && $0.password == password
        }) {
            loggedInUser = account
            isLoggedIn = true
            clearFields()
        } else {
            showAlert(message: "Wrong Username or Password")
            clearFields()
        }
    }
    
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
    
    private func clearFields() {
        username = ""
        password = ""
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
    
    @FetchRequest(
        entity: Account_info.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Account_info.uuid, ascending: false)]
    )
    var account_info: FetchedResults<Account_info>
    
    @State private var newUsername = ""
    @State private var newPassword = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("New Username", text: $newUsername)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .foregroundColor(.secondary)
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .keyboardType(.asciiCapable)

                SecureField("New Password", text: $newPassword)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .foregroundColor(.secondary)
                    .cornerRadius(10)
                    .keyboardType(.numberPad)

                Button("Register") {
                    print("注册账号：\(newUsername)，密码：\(newPassword)")
                    
                    let new_account = Account_info(context: viewContext)
                    new_account.username = newUsername
                    new_account.password = newPassword
                    new_account.uuid = UUID()
                    do {
                        try viewContext.save()
                        dismiss()
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
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
