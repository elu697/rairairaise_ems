//
//  PDFDownloader.swift
//  ems
//
//  Created by 吉野瑠 on 2019/12/12.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class PDFDownloader: NSObject {
    internal static let shared = PDFDownloader()

    var pdfUrl: URL?

    override private init() {}
    
    func download(fileName: String, param: [Assets], _ completion: @escaping (Error?) -> Void) {
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            if let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentsURL.appendingPathComponent(fileName)
                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            } else {
                return (URL(fileURLWithPath: ""), [.removePreviousFile, .createIntermediateDirectories])
            }
        }
        
        let data: [[String]] = param.map { ["123123", $0.code, $0.name ?? ""] }
        let url = "https://rairairaise.appspot.com/api/qr"
        Alamofire.download(url, method: .post, parameters: ["data": data], encoding: JSONEncoding.default, to: destination).response { response in
            completion(response.error)
        }
    }
}

