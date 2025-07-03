//
//  RemoteService.swift
//  OS Image Download Tool
//
//  Created by Матвей on 2025-07-03.
//

import Foundation
import Combine

/// Ошибки, которые может выбросить RemoteService
enum RemoteServiceError: Error {
    case invalidURL
    case invalidResponse(statusCode: Int)
}

/// Сервис для получения списка образов из удалённого каталога.
/// Ожидает, что на сервере лежат JSON-файлы вида:
///   [{
///     "id": "UUID-string",
///     "name": "macOS_Ventura.iso",
///     "url": "https://…/macos_ventura.iso",
///     "size": 8589934592,
///     "osType": "macOS"
///   }, …]
struct RemoteService {
    /// Базовый URL вашего каталога.
    /// В реальном проекте замените на URL вашего API (Mediafire/Yandex-Disk/Google-Drive или свой собственный сервер).
    private let baseURLString = "https://yourserver.com/images"

    /// Загружает список образов для выбранной платформы.
    /// - Parameter platform: Платформа (macOS, Windows, Linux и т. д.).
    /// - Returns: `AnyPublisher<[ImageItem], Error>` с массивом распарсенных `ImageItem`.
    func fetchImageList(for platform: OSType) -> AnyPublisher<[ImageItem], Error> {
        // Формируем URL вида https://yourserver.com/images/macos.json
        guard var components = URLComponents(string: baseURLString) else {
            return Fail(error: RemoteServiceError.invalidURL).eraseToAnyPublisher()
        }
        components.path += "/\(platform.rawValue.lowercased()).json"
        guard let url = components.url else {
            return Fail(error: RemoteServiceError.invalidURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let http = response as? HTTPURLResponse else {
                    throw RemoteServiceError.invalidResponse(statusCode: -1)
                }
                guard http.statusCode == 200 else {
                    throw RemoteServiceError.invalidResponse(statusCode: http.statusCode)
                }
                return data
            }
            .decode(type: [ImageItem].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
