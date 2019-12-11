//
//  FileIO.swift
//  ems
//
//  Created by 吉野瑠 on 2019/12/11.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation

class FileIO {
    static internal func load(fileName: String) -> [String]? {
        var csvData: [String]? = nil
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let pathFileName = dir.appendingPathComponent(fileName)
            do {
                let csv = try String(contentsOf: pathFileName, encoding: .shiftJIS)
                csvData = csv.lines
            } catch(let e) {
                print("読み込み失敗: \(e.localizedDescription)")
            }
        }
        return csvData
    }
    
    static internal func save(data: Data, fileName: String) -> Bool {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let pathFileName = dir.appendingPathComponent(fileName)
            do {
                try data.write(to: pathFileName)
            } catch {
                print("書き込み失敗")
                return false
            }
        }
        return true
    }
}
