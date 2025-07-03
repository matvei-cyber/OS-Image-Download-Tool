//
//  ImageListViewModel.swift
//  OS Image Download Tool
//
//  Created by Матвей on 2025-07-03.
//

import Foundation
import Combine
import SwiftUI

/// ViewModel для списка образов и управления загрузкой
final class ImageListViewModel: ObservableObject {
    // MARK: — Публичные свойства для биндинга
    
    /// Список доступных образов
    @Published var items: [ImageItem] = []
    /// Выбранная платформа (macOS, Windows, Linux и т.д.)
    @Published var selectedPlatform: OSType = .macOS {
        didSet { refresh() }
    }
    /// Выбранный образ
    @Published var selectedItem: ImageItem?
    /// Флаг, что идёт загрузка
    @Published var isDownloading: Bool = false
    /// Текущее значение прогресса (0.0–1.0)
    @Published var downloadProgress: Double = 0.0
    
    // MARK: — Сервисы и Combine
    
    private let remoteService = RemoteService()
    private let downloadService = DownloadService()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: — Инициализация
    
    init() {
        // При старте сразу подгрузим список для платформы по-умолчанию
        refresh()
    }
    
    // MARK: — Публичные методы
    
    /// Обновляет список образов для текущей платформы
    func refresh() {
        // Сброс предыдущего состояния
        items = []
        selectedItem = nil
        isDownloading = false
        downloadProgress = 0.0
        
        remoteService
            .fetchImageList(for: selectedPlatform)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    // Обработка ошибки: можно показать алерт в UI
                    print("Ошибка при загрузке списка: \(error)")
                }
            }, receiveValue: { [weak self] list in
                self?.items = list
            })
            .store(in: &cancellables)
    }
    
    /// Начинает загрузку выбранного образа
    func startDownload() {
        guard let item = selectedItem, !isDownloading else { return }
        
        isDownloading = true
        downloadProgress = 0.0
        
        downloadService
            .download(from: item.url)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isDownloading = false
                switch completion {
                case .finished:
                    print("Загрузка завершена")
                case .failure(let error):
                    print("Ошибка во время загрузки: \(error)")
                }
            }, receiveValue: { [weak self] progressInfo in
                guard let self = self else { return }
                self.downloadProgress = progressInfo.fractionCompleted
                
                // Если получили файл во временном местоположении — переместить его в папку Загрузок
                if let tmpURL = progressInfo.fileLocation {
                    do {
                        let downloads = FileManager.default.urls(
                            for: .downloadsDirectory, in: .userDomainMask
                        ).first!
                        let destURL = downloads.appendingPathComponent(item.name)
                        
                        // Если файл уже есть — удалить старый
                        if FileManager.default.fileExists(atPath: destURL.path) {
                            try FileManager.default.removeItem(at: destURL)
                        }
                        try FileManager.default.moveItem(at: tmpURL, to: destURL)
                        print("Файл сохранён в \(destURL.path)")
                    } catch {
                        print("Не удалось сохранить файл: \(error)")
                    }
                }
            })
            .store(in: &cancellables)
    }
    
    // MARK: — Заглушка для SwiftUI Preview
    
    /// Превью с тестовыми данными
    static var preview: ImageListViewModel {
        let vm = ImageListViewModel()
        vm.items = [
            ImageItem(
                id: UUID(),
                name: "macOS_Ventura.iso",
                url: URL(string: "https://example.com/macos_ventura.iso")!,
                size: 8_589_934_592,
                osType: .macOS
            ),
            ImageItem(
                id: UUID(),
                name: "Windows_11.iso",
                url: URL(string: "https://example.com/windows_11.iso")!,
                size: 5_368_709_120,
                osType: .windows
            ),
            ImageItem(
                id: UUID(),
                name: "Xcode_14.3.1.xip",
                url: URL(string: "https://example.com/xcode_14.3.1.xip")!,
                size: 13_000_000_000,
                osType: .xcode
            )
        ]
        vm.selectedItem = vm.items.first
        return vm
    }
}
