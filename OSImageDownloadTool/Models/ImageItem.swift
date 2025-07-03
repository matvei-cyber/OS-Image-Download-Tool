//
//  ImageItem.swift
//  OS Image Download Tool
//
//  Created by Матвей on 2025-07-03.
//

import Foundation

/// Типы поддерживаемых образов
enum OSType: String, CaseIterable, Identifiable, Codable {
    case macOS = "macOS"
    case windows = "Windows"
    case xcode = "Xcode"
    
    var id: String { rawValue }
}

/// Модель одного образа для загрузки
struct ImageItem: Identifiable, Codable, Equatable, Hashable {
    /// Уникальный идентификатор
    let id: UUID
    /// Читабельное имя файла
    let name: String
    /// Прямая ссылка для скачивания
    let url: URL
    /// Размер в байтах
    let size: Int
    /// Тип образа
    let osType: OSType
}

// MARK: — Пример JSON для справки
/*
[
  {
    "id": "C56A4180-65AA-42EC-A945-5FD21DEC0538",
    "name": "macOS_Ventura.iso",
    "url": "https://cdn.yourserver.com/isos/macos_ventura.iso",
    "size": 8589934592,
    "osType": "macOS"
  },
  {
    "id": "D56B4281-76BB-53FD-B256-6AE31FEC1649",
    "name": "macOS_Monterey.iso",
    "url": "https://cdn.yourserver.com/isos/macos_monterey.iso",
    "size": 7205759404,
    "osType": "macOS"
  }
]
*/
