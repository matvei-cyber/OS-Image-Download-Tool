//
//  OSImageDownloadToolApp.swift
//  OS Image Download Tool
//
//  Created by Матвей on 2025-07-03.
//

import SwiftUI

@main
struct OSImageDownloadToolApp: App {
    // ViewModel, управляющий списком образов и состоянием загрузки
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var viewModel = ImageListViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .frame(minWidth: 600, minHeight: 400) // минимальный размер окна
        }
        .commands {
            // Можно добавить кастомные меню, если потребуется
            CommandGroup(before: .appInfo) {
                Button("О программе OS Image Download Tool") {
                    // показать окно About
                    NSApp.orderFrontStandardAboutPanel(options: [:])
                }
            }
        }
    }
}
