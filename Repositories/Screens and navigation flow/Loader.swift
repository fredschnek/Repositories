//
//  Loader.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 17/09/22.
//

import UIKit
import Foundation

struct Loader {
    static func loadDataFromJSONFile<Model: Decodable>(withName name: String) -> Model? {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return nil
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard let model = try? decoder.decode(Model.self, from: data) else {
            return nil
        }
        return model
    }
}
