//
//  FILE.swift
//  MagicRules
//
//  Created by Liu Zhe on 2023-05-05.
//

import Foundation

struct FileManagerWrapper {
    enum Error: Swift.Error {
        case fileNotFound
        case invalidData
    }
    
    static func readUrls(from fileName: String) throws -> [URL] {
        let fileManager = FileManager.default
        let currentPath = fileManager.currentDirectoryPath
        let url = URL(fileURLWithPath: currentPath)
        
        let fileURL = url.appendingPathComponent(fileName)
        
        do {
            let contents = try String(contentsOf: fileURL, encoding: .utf8)
            let urls = contents.split{$0.isNewline}
            
            var urlArray: [URL] = []
            for urlString in urls {
                guard let url = URL(string: String(urlString)) else {
                    throw Error.invalidData
                }
                
                urlArray.append(url)
            }
            
            return urlArray
        } catch {
            throw Error.fileNotFound
        }
    }
    
    static func writeFile(data: String, to fileName: String){
        let fileManager = FileManager.default
        let currentPath = fileManager.currentDirectoryPath
        let url = URL(fileURLWithPath: currentPath)
        
        let fileURL = url.appendingPathComponent(fileName)
        do{
            try data.write(to: fileURL, atomically: true, encoding: .utf8)
            print("已写入文件 \(fileURL.absoluteString)")
        }catch let error {
            print(error.localizedDescription)
        }
    }
}
