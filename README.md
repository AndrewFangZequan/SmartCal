# 📱 SmartCal – A Mental Arithmetic App for Kids

> 🌐 [Read this in Chinese 中文版](./README.zh.md)

**SmartCal** is a SwiftUI-based iOS application designed to help children practice mental arithmetic. It features a simple login system, persistent user data using Core Data, and a user-friendly interface suitable for young users.

---

## ✨ Features

- 👤 **User Account System**
  - Register and log in with a local account (username + password)
  - Each user has an isolated data environment
  - Supports multiple accounts on the same device

- 🧠 **Personalized Practice Data**
  - Each user's practice results and progress are stored separately
  - Designed to scale with different user profiles

- 💾 **Local Data Persistence (Core Data)**
  - All data is saved locally using Core Data
  - Data persists across app restarts without needing a server

- 🎨 **Beautiful and Accessible UI**
  - Blurred glass-style login interface
  - Dark mode support
  - Animated SF Symbols (e.g. wiggle effects)

---

## 📸 Screenshots

*(Add screenshots here if available)*

---

## 🛠 Technologies Used

- **SwiftUI** – modern, declarative UI framework
- **Core Data** – local data storage and user management
- **Xcode** – iOS app development environment

---

## 🚀 Getting Started

To build and run the project:

1. Clone this repository.
2. Open `SmartCal.xcodeproj` in Xcode.
3. Run the app on a simulator or real device.

> 📌 Requires Xcode 14+ and iOS 16+ for `NavigationStack` and modern SwiftUI APIs.

---

## 📂 Project Structure

- `ContentView.swift` – login screen and navigation logic
- `RegisterView.swift` – user registration view
- `MainView.swift` – post-login main screen showing user-specific content
- `Persistence.swift` – Core Data stack setup

---

## ✅ Roadmap Ideas

- Add arithmetic problem generation (addition, subtraction, etc.)
- Track user scores and progress
- Daily challenge system
- Export performance reports for parents

---

## 🙌 Credits

Developed by [Your Name / Team Name].  
For learning and educational purposes.

---

## 📄 License

This project is licensed under the MIT License.
