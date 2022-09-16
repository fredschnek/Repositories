//
//  FileSystemCacheController.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 16/09/22.
//

import Foundation

typealias Bytes = CLongLong

class FileSystemCacheController {
    var cacheSize: Bytes {
        let size = fileAttributes(for: gitHubCacheDirectoryURL)?[.size] as? Int
        return size.map(Bytes.init) ?? 0
    }
    
    var entries: [StoredEntry] {
        func fetchEntry(for url: URL, with keys: [URLResourceKey]) -> StoredEntry? {
            assert(url.isFileURL, "Stored entries can only be created from file URLs")
            guard let values = try? url.resourceValues(forKeys: Set(keys)) else {
                return nil
            }
            return StoredEntry(url: url, values: values)
        }
        
        func contentsOfDirectory(at url: URL, for keys: [URLResourceKey]) -> [URL] {
            return (try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: keys))
            ?? []
        }
        
        let keys: [URLResourceKey] = [.creationDateKey, .fileSizeKey]
        return contentsOfDirectory(at: gitHubCacheDirectoryURL, for: keys)
            .compactMap { fetchEntry(for: $0, with: keys) }
    }
    
    func store<T: Encodable>(value: T, for url: URL) {
        guard let data = try? JSONEncoder().encode(value),
              let fileURL = url.fileUrl(withBaseURL: gitHubCacheDirectoryURL) else {
            return
        }
        try? data.write(to: fileURL)
    }
    
    func fetchValue<T: Decodable>(for url: URL) -> StoredValue<T>? {
        func creationDateForFile(at url: URL) -> Date? {
            guard let attributes = fileAttributes(for: url),
                  let date = attributes[.creationDate] as? Date else {
                return nil
            }
            return date
        }
        
        func extractValue<U: Decodable>(for url: URL) -> U? {
            guard let data = try? Data(contentsOf: url),
                  let value = try? JSONDecoder().decode(U.self, from: data) else {
                return nil
            }
            return value
        }
        
        guard let fileURL = url.fileUrl(withBaseURL: gitHubCacheDirectoryURL) else {
            return nil
        }
        guard let date = creationDateForFile(at: fileURL),
              let value: T = extractValue(for: fileURL) else {
            return nil
        }
        return StoredValue(value: value, date: date)
    }
    
    func removeValue(for url: URL) {
        url.fileUrl(withBaseURL: gitHubCacheDirectoryURL)
            .map { try? FileManager.default.removeItem(at: $0) }
    }
}

// MARK: - Private

private extension FileSystemCacheController {
    var gitHubCacheDirectoryURL: URL {
        return FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first!.appendingPathComponent("githubAPICache")
    }
    
    func fileAttributes(for url: URL) -> [FileAttributeKey : Any]? {
        assert(url.isFileURL, "File attributes exist only for file URLs")
        return try? FileManager.default.attributesOfItem(atPath: url.absoluteString)
    }
}

// MARK: - StoredEntry

extension StoredEntry {
    init?(url: URL, values: URLResourceValues) {
        guard let date = values.creationDate,
              let size = values.fileSize else {
            return nil
        }
        self.url = url
        self.date = date
        self.size = Bytes(size)
    }
}

// MARK: - URL

extension URL {
    func fileUrl(withBaseURL baseURL: URL) -> URL? {
        assert(!isFileURL, "A file URL can be created only for a web URL, to avoid double indirection in the encoding")
        guard let percentEscaped = absoluteString.addingPercentEncoding(withAllowedCharacters: .alphanumerics) else {
            return nil
        }
        return baseURL
            .appendingPathComponent(percentEscaped)
            .appendingPathExtension("json")
    }
}

