//
//  DownloadService.swift
//  OS Image Download Tool
//
//  Created by Матвей on 2025-07-03.
//

import Foundation
import Combine

/// Информационный объект прогресса загрузки
struct DownloadProgress {
    /// Доля выполненной работы от 0.0 до 1.0
    let fractionCompleted: Double
    /// Локальный URL временного файла (nil до завершения)
    let fileLocation: URL?
}

/// Сервис для загрузки одного файла с поддержкой Combine и прогресса
final class DownloadService: NSObject {
    private var session: URLSession!
    private var progressSubject: PassthroughSubject<DownloadProgress, Error>?
    
    override init() {
        super.init()
        // Инициализируем URLSession с нашим делегатом
        let cfg = URLSessionConfiguration.default
        session = URLSession(configuration: cfg, delegate: self, delegateQueue: nil)
    }
    
    /// Запустить загрузку файла по URL
    /// - Parameter url: удалённый URL файла
    /// - Returns: паблишер, который шлёт обновления прогресса и завершает с final DownloadProgress или ошибкой
    func download(from url: URL) -> AnyPublisher<DownloadProgress, Error> {
        // Создаём новый субъект для этой загрузки
        let subject = PassthroughSubject<DownloadProgress, Error>()
        self.progressSubject = subject
        
        // Стартуем задачу
        let task = session.downloadTask(with: url)
        task.resume()
        
        return subject
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

extension DownloadService: URLSessionDownloadDelegate {
    // Вызывается по мере скачивания данных
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        guard let subject = progressSubject else { return }
        // Вычисляем прогресс
        let fraction = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        subject.send(DownloadProgress(fractionCompleted: fraction, fileLocation: nil))
    }
    
    // Вызывается, когда файл полностью загружен во временное хранилище
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        guard let subject = progressSubject else { return }
        // Финальный прогресс = 1.0 и возвращаем URL временного файла
        subject.send(DownloadProgress(fractionCompleted: 1.0, fileLocation: location))
        subject.send(completion: .finished)
        progressSubject = nil
    }
    
    // Вызывается при ошибке задачи
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?) {
        guard let subject = progressSubject, let err = error else { return }
        subject.send(completion: .failure(err))
        progressSubject = nil
    }
}
