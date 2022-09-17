//
//  FileSystemCacheController.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 16/09/22.
//

import Foundation

typealias Bytes = CLongLong

class FileSystemCacheController {
    private let gitHubDirectory = GitHubDirectory(
        iOSCachesDirectoryURL: FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first!
    )
    
    var cacheSize: Bytes {
        let size = fileAttributes(for: gitHubDirectory.iOSCachesDirectoryURL)?[.size] as? Int
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
        return contentsOfDirectory(at: gitHubDirectory.baseURL, for: keys)
            .compactMap { fetchEntry(for: $0, with: keys) }
    }
    
    func store<T: Encodable>(value: T, for url: URL) {
        gitHubDirectory
            .makeStorableData(value: value, url: url)
            .map { storableData in try? storableData.data.write(to: storableData.fileURL) }
    }
    
    func fetchValue<T: Decodable>(for url: URL) -> StoredValue<T>? {
        func creationDateForFile(at url: URL) -> Date? {
            assert(url.isFileURL, "The creation date exists only for file URLs")
            guard let values = try? url.resourceValues(forKeys: Set([.creationDateKey])),
                  let date = values.creationDate else {
                return nil
            }
            return date
        }
        
        func extractValue<U: Decodable>(for url: URL) -> U? {
            return (try? Data(contentsOf: url)).flatMap(GitHubDirectory.value(from:))
        }
        
        guard let fileURL = url.fileUrl(withBaseURL: gitHubDirectory.baseURL) else {
            return nil
        }
        guard let date = creationDateForFile(at: fileURL),
              let value: T = extractValue(for: fileURL) else {
            return nil
        }
        return StoredValue(value: value, date: date)
    }
    
    func removeValue(for url: URL) {
        url.fileUrl(withBaseURL: gitHubDirectory.iOSCachesDirectoryURL)
            .map { try? FileManager.default.removeItem(at: $0) }
        
    }
}

// MARK: - Private

private extension FileSystemCacheController {
    func fileAttributes(for url: URL) -> [FileAttributeKey : Any]? {
        assert(url.isFileURL, "File attributes exist only for file URLs")
        return try? FileManager.default.attributesOfItem(atPath: url.absoluteString)
    }
}

// MARK: - GitHubDirectory

extension FileSystemCacheController {
    struct GitHubDirectory {
        static let name = "githubAPICache"
        let iOSCachesDirectoryURL: URL
        
        var baseURL: URL {
            return iOSCachesDirectoryURL.appendingPathComponent(GitHubDirectory.name)
        }
        
        static func value<V: Decodable>(from data: Data) -> V? {
            return try? JSONDecoder().decode(V.self, from: data)
        }
        
        func makeStorableData<V: Encodable>(value: V, url: URL) -> StorableData? {
            guard let data = try? JSONEncoder().encode(value),
                  let fileURL = url.fileUrl(withBaseURL: baseURL) else {
                return nil
            }
            return StorableData(data: data, fileURL: fileURL)
        }
    }
}

// MARK: - StorableData

extension FileSystemCacheController.GitHubDirectory {
    struct StorableData {
        let data: Data
        let fileURL: URL
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
