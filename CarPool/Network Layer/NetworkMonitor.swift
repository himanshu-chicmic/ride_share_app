//
//  NetworkConnection.swift
//  CarPool
//
//  Created by Himanshu on 6/26/23.
//

import Foundation
import Network

class NetworkMonitor {
    
    // MARK: - properties
    
    // shared instance for NetworkMonitor
    static let shared = NetworkMonitor()
    
    let monitor = NWPathMonitor()
    private var status: NWPath.Status = .requiresConnection
    
    var isReachable: Bool { status == .satisfied }
    var isReachableOnCellular: Bool = true
    
    // MARK: - methods
    
    /// method to start network monitoring
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.status = path.status
            self?.isReachableOnCellular = path.isExpensive
            
            if path.status == .unsatisfied {
                self?.status = path.status
            } else {
                self?.status = .satisfied
            }
        }
        
        let queue = DispatchQueue(label: Constants.Network.monitor)
        monitor.start(queue: queue)
    }
    
    /// method to stop network monitoring
    func stopMonitoring() {
        monitor.cancel()
    }
}
