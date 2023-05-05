//
//  main.swift
//  MagicRules
//
//  Created by Liu Zhe on 2023-05-05.
//

import Foundation

func main() async {
    let urls = [URL(string: "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/direct.txt")!,URL(string: "https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/proxy.txt")!]
    urls.forEach { url in
        Task {
            let data = try await Network.fetchString(from: url).replacingOccurrences(of: "  - '", with: "").replacingOccurrences(of: "+.", with: "").replacingOccurrences(of: "'", with: "")
            let lines = data.split{$0.isNewline}
            let uniqueArray = Array(Set(lines.map { $0.components(separatedBy: ".").suffix(2).joined(separator: ".") }))
            let filteredArray = uniqueArray.filter { !($0.contains(".cn") || $0.contains("-cn")) }
            var action = "proxy"
            var fileName = "proxy.txt"
            var header = ""
            if url.absoluteString.contains("direct") {
                action = "direct"
                fileName = "direct.txt"
                header = "host-suffix,cn,direct\nhost-keyword,-cn,direct\n"
            }
            let resultArray = filteredArray.map { "host-suffix,\($0),\(action)" }
            let result = header + resultArray.joined(separator: "\n")
            
            FileManagerWrapper.writeFile(data: result, to: fileName)
        }
    }
}


await main();


_ = readLine()
