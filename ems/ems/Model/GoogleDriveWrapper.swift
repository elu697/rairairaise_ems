//
//  GoogleDriveWrapper.swift
//  ems
//
//  Created by 吉野瑠 on 2019/12/06.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

internal class GoogleDriveWrapper {
    public static var shared = GoogleDriveWrapper()
    private var service = GTLRDriveService()
    public var driveService: GTLRDriveService {
        get {
            return service
        }
    }

    private init() {}

    public func setService(service: GTLRDriveService) {
        self.service = service
    }

    public func search(_ fileName: String, _ completion: @escaping (String?, Error?) -> Void) {
        let query = GTLRDriveQuery_FilesList.query()
        query.pageSize = 1
        query.q = "name contains '\(fileName)'"

        service.executeQuery(query) { _, results, error in
            completion((results as? GTLRDrive_FileList)?.files?.first?.identifier, error)
        }
    }

    public func download(_ fileID: String, _ completion: @escaping (Data?, Error?) -> Void) {
        let query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: fileID)
        service.executeQuery(query) { _, file, error in
            completion((file as? GTLRDataObject)?.data, error)
        }
    }

    public func download(_ fileID: String, onCompleted: @escaping (Data?, Error?) -> Void) {
        let query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: fileID)
        service.executeQuery(query) { _, file, error in
            onCompleted((file as? GTLRDataObject)?.data, error)
        }
    }

    public func listFilesInFolder(_ folder: String, _ completion: @escaping (GTLRDrive_FileList?, Error?) -> Void) {
        search(folder) { folderID, error in
            guard let ID = folderID else {
                completion(nil, error)
                return
            }
            self.listFiles(ID, completion)
        }
    }

    private func listFiles(_ folderID: String, _ completion: @escaping (GTLRDrive_FileList?, Error?) -> Void) {
        let query = GTLRDriveQuery_FilesList.query()
        query.pageSize = 100
        query.q = "'\(folderID)' in parents"

        service.executeQuery(query) { _, result, error in
            completion(result as? GTLRDrive_FileList, error)
        }
    }
}
