//
//  ReachabilityObserverDelegate.swift
//  ems
//
//  Created by El You on 2019/12/11.
//  Copyright © 2019 RaiRaiRaise. All rights reserved.
//

import Foundation
import Reachability

//Reachability
//declare this property where it won't go out of scope relative to your listener
fileprivate var reachability: Reachability!

protocol ReachabilityActionDelegate {
    func reachabilityChanged(_ isReachable: Bool)
}

protocol ReachabilityObserverDelegate: AnyObject, ReachabilityActionDelegate {
    func addReachabilityObserver()
    func removeReachabilityObserver()
}

// Declaring default implementation of adding/removing observer
extension ReachabilityObserverDelegate {
    /** Subscribe on reachability changing */
    func addReachabilityObserver() {
        do {
            try reachability = Reachability()
        } catch {
            print("error")
        }


        reachability.whenReachable = { [weak self] reachability in
            self?.reachabilityChanged(true)
        }

        reachability.whenUnreachable = { [weak self] reachability in
            self?.reachabilityChanged(false)
        }

        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }

    /** Unsubscribe */
    func removeReachabilityObserver() {
        reachability.stopNotifier()
        reachability = nil
    }
}
