//
//  AppDelegate.swift
//  OS Image Download Tool
//
//  Created by Матвей on 2025-07-03.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Здесь можно сделать первоначальную настройку:
        // — регистрация глобальных шорткатов,
        // — настройка логгирования,
        // — проверка обновлений приложения и т. п.
        print("OS Image Download Tool запущен")
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        // Сюда поместить код очистки перед выходом:
        // — сохранение состояния,
        // — завершение фоновых задач и т. д.
        print("OS Image Download Tool завершает работу")
    }
}
