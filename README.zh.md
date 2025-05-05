# 📱 SmartCal – 儿童口算辅助 App

> 🌐 [View English Version / 英文版](./README.md)

**SmartCal** 是一个使用 SwiftUI 构建的 iOS 应用，旨在帮助儿童练习口算。应用支持账号登录与注册，结合 Core Data 实现用户数据的本地持久化，并拥有适合儿童的美观界面设计。

---

## ✨ 功能特色

- 👤 **用户系统**
  - 支持本地注册与登录（用户名 + 密码）
  - 每个用户拥有独立的数据环境
  - 多账号共存、数据互不干扰

- 🧠 **个性化练习数据**
  - 每个账号对应唯一练习数据
  - 后续可扩展为跟踪用户进度、错题集等

- 💾 **本地数据存储（Core Data）**
  - 使用 Core Data 保存账号信息与数据
  - 数据不依赖网络，App 重启后仍保留

- 🎨 **美观交互界面**
  - 支持毛玻璃风格背景登录页
  - 深色模式适配
  - 使用系统 SF Symbols 动效（如 wiggle）

---

## 📸 界面截图

（此处可添加登录界面和主界面截图）

---

## 🛠 技术栈

- **SwiftUI** – 声明式 UI 框架
- **Core Data** – 本地数据库系统
- **Xcode** – iOS 开发环境

---

## 🚀 快速开始

1. 克隆此仓库
2. 使用 Xcode 打开 `SmartCal.xcodeproj`
3. 真机或模拟器运行

> 📌 推荐 Xcode 14+，iOS 16+，以支持 NavigationStack 等新特性

---

## 📂 项目结构说明

- `ContentView.swift` – 登录页面与导航逻辑
- `RegisterView.swift` – 用户注册界面
- `MainView.swift` – 登录后主界面，显示用户内容
- `Persistence.swift` – Core Data 栈设置

---

## ✅ 后续开发计划

- 自动生成口算题目（加减乘除）
- 记录答题时间与正确率
- 家长可查看成绩报告
- 用户头像与积分系统

---

## 🙌 致谢

由 [你的名字] 开发，作为学习与展示用 SwiftUI 项目。

---

## 📄 License

本项目使用 MIT 开源协议。
