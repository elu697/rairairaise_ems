//
//  PDFDownloader.swift
//  ems
//
//  Created by 竹原健太 on 2019/12/06.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//
import UIKit

class PDFDownloader: NSObject {
    internal static let share = PDFDownloader()

    var pdfUrl: URL?

    override private init() {}

    func download() {
        let urlString = "https://www.tutorialspoint.com/swift/swift_tutorial.pdf"

        let url = URL(string: urlString)
        let fileName = String((url!.lastPathComponent)) as NSString
        // Create destination URL
        let documentsUrl: URL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as URL?)!
        let destinationFileUrl = documentsUrl.appendingPathComponent("\(fileName)")
        //Create URL to the source file you want to download
        let fileURL = URL(string: urlString)
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = URLRequest(url: fileURL!)
        let task = session.downloadTask(with: request) { tempLocalUrl, response, error in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Successfully downloaded. Status code: \(statusCode)")
                }
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationFileUrl)
                    do {
                        //Show UIActivityViewController to save the downloaded file
                        let contents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                        for indexx in 0..<contents.count {
                            if contents[indexx].lastPathComponent == destinationFileUrl.lastPathComponent {
                                let activityViewController = UIActivityViewController(activityItems: [contents[indexx]], applicationActivities: nil)
                            }
                        }
                    } catch (let err) {
                        print("error: \(err)")
                    }
                } catch (let writeError) {
                    print("Error creating a file \(destinationFileUrl) : \(writeError)")
                }
            } else {
                print("Error took place while downloading a file. Error description: \(error?.localizedDescription ?? "")")
            }
        }
        task.resume()
    }
}
