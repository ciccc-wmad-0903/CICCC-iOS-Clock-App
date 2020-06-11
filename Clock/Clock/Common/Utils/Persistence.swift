//
//  Persistence.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-09.
//  Copyright © 2020 CICCC. All rights reserved.
//

import Foundation

class Persistence {
    
    static func saveData<E: Encodable>(data: E, plistName: String, onCompletion: (() -> ())? = nil, onError: ((Error) -> ())? = nil) {
        if let encodedStopwatch = try? PropertyListEncoder().encode(data) {
            do {
                try encodedStopwatch.write(to: getArchiveURL(with: plistName), options: .noFileProtection)
                onCompletion?()
            } catch {
                onError?(error)
            }
        }
    }
    
    static func loadData<D: Decodable>(_ returnType: D.Type, plistName: String) -> D? {
        if let retrievedData = try? Data(contentsOf: getArchiveURL(with: plistName)),
            let decodedData = try? PropertyListDecoder().decode(D.self, from: retrievedData) {
            return decodedData
        } else {
            return nil
        }
    }
    
    static private func getArchiveURL(with plistName: String) -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(plistName).appendingPathExtension("plist")
    }
    
}
