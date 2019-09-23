//
//  Dispatch.swift
//  ems
//
//  Created by 吉野瑠 on 2019/09/01.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation

internal class Dispatch {
    private var group: DispatchGroup
    private var queues: [String: DispatchQueue] = [:]
    private var label: String
    
    internal init(label: String) {
        group = DispatchGroup()
        self.label = label
    }
    
    internal func async(_ imp: @escaping () -> Void) {
        group.enter()
        if let queue = queues[label] {
            queue.async(group: group, qos: .unspecified, flags: [], execute: imp)
        } else {
            queues[label] = DispatchQueue(label: label, attributes: .concurrent)
            queues[label]?.async(group: group, qos: .unspecified, flags: [], execute: imp)
        }
    }
    
    internal func notify(_ imp: @escaping () -> Void) {
        if let queue = queues[label] {
            group.notify(queue: queue, execute: imp)
        } else {
            print("Dispatch func notify: label not found")
        }
    }
    
    internal func leave() {
        group.leave()
    }
}
