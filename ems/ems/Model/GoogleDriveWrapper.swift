//
//  GoogleDriveWrapper.swift
//  ems
//
//  Created by 吉野瑠 on 2019/12/06.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import GoogleAPIClientForREST

internal enum GoogleDriveMime: String {
    case folder = "application/vnd.google-apps.folder"
    case csv = "text/csv"
}

internal enum GDriveError: Error {
    case noDataAtPath
}

internal class GoogleDriveWrapper {
    public static var shared = GoogleDriveWrapper()
    private var service = GTLRDriveService()
    public var driveService: GTLRDriveService {
        return service
    }

    private enum Mode {
        case root
        case search(folderID: String)

        fileprivate var query: String {
            switch self {
            case .root:
                return "'root' in parents and trashed = false"
            case .search(let folderID):
                return "'\(folderID)' in parents"
            }
        }
    }

    private init() {
        service.isRetryEnabled = true
    }

    public func download(_ fileID: String, _ completion: @escaping (Data?, Error?) -> Void) {
        let query = GTLRDriveQuery_FilesGet.queryForMedia(withFileId: fileID)
        service.executeQuery(query) { _, file, error in
            completion((file as? GTLRDataObject)?.data, error)
        }
    }

    public func listFilesInRoot(_ completion: @escaping (GTLRDrive_FileList?, Error?) -> Void) {
        listFiles(.root, completion)
    }

    public func listFilesInFolder(_ folderID: String, _ completion: @escaping (GTLRDrive_FileList?, Error?) -> Void) {
        listFiles(.search(folderID: folderID), completion)
    }

    public func uploadFile(folderID: String, filePath: String, mimeType: String, completion: ((String?, Error?) -> Void)?) {
        guard let data = FileManager.default.contents(atPath: filePath) else {
            completion?(nil, GDriveError.noDataAtPath)
            return
        }

        let file = GTLRDrive_File()
        file.name = filePath.components(separatedBy: "/").last
        file.parents = [folderID]

        let uploadParams = GTLRUploadParameters(data: data, mimeType: mimeType)
        uploadParams.shouldUploadWithSingleRequest = true

        let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: uploadParams)
        query.fields = "id"

        service.executeQuery(query, completionHandler: { _, file, error in
            completion?((file as? GTLRDrive_File)?.identifier, error)
        }
        )
    }

    private func listFiles(_ mode: Mode, _ completion: @escaping (GTLRDrive_FileList?, Error?) -> Void) {
        let query = GTLRDriveQuery_FilesList.query()
        query.pageSize = 100
        query.q = "\(mode.query) and (mimeType = 'application/vnd.google-apps.folder' or mimeType = 'text/csv')"
        query.orderBy = "folder"

        service.executeQuery(query) { _, result, error in
            completion(result as? GTLRDrive_FileList, error)
        }
    }
}
