//
//  NetworkManager.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 8.04.2021.
//

import Foundation
import Network

class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor : NWPathMonitor
    
    public private(set) var  isConnected : Bool = false
    
    private init(){
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring(){
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
    }
    
    public func stopMonitoring(){
        monitor.cancel()
    }
    
    
    
}
