//
// Swift usefull extensions
//

import FirebaseFirestore
import Foundation
import Pring
import PromiseKit

extension Document where Self: Object {
    internal static func isExist(keyPath: PartialKeyPath<Self>, value: Any?, _ exist: @escaping (DocumentReference?, Error?) -> Void) {
        guard let value = value else { exist(nil, NSError(domain: "not input value", code: -1, userInfo: nil)); return }
        if let key = keyPath._kvcKeyPathString {
            Self.where(key, isEqualTo: value).get { snapShot, error in
                if let error = error {
                    exist(nil, error)
                } else {
                    guard let snapShot = snapShot else { exist(nil, error); return }
                    exist(snapShot.isEmpty ? nil : snapShot.documents[0].reference, nil)
                }
            }
        }
    }

    static func existCheck(keyPath: PartialKeyPath<Self>, value: Any?) -> Promise<[DocumentReference]> {
        return Promise<[DocumentReference]> { seal in
            guard let value = value else {
                seal.reject(DBStoreError.inputFailed)
                return
            }
            if let key = keyPath._kvcKeyPathString {
                Self.where(key, isEqualTo: value).get { snapShot, _ in
                    guard let snapShot = snapShot, !snapShot.isEmpty else {
                        seal.fulfill([])
                        return
                    }
                    seal.fulfill([snapShot.documents[0].reference])
                }
            } else {
                seal.reject(DBStoreError.failed)
            }
        }
    }

    func save() -> Promise<[DocumentReference]> {
        Promise<[DocumentReference]> { seal in
            save { docRef, error in
                if let docRef = docRef {
                    seal.resolve(error, [docRef])
                } else {
                    seal.resolve(error, [])
                }
            }
        }
    }
    
    func delete() -> Promise<Void> {
        Promise<Void> { seal in
            delete { error in
                if error != nil {
                    seal.reject(DBStoreError.failed)
                } else {
                    seal.fulfill_()
                }
            }
        }
    }
}
