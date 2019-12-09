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
