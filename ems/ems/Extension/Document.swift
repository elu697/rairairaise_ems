//
// Swift usefull extensions
//

import FirebaseFirestore
import Foundation
import Pring

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
}
