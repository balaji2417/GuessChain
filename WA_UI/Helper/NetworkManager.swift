//
//  NetworkManager.swift
//  WA_UI
//

import Foundation
import Network
import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let monitor = NWPathMonitor()
    var isConnected: Bool = true
    private weak var currentVC: UIViewController?
    private var isShowingAlert: Bool = false
    private var lastAlertTime: Date?
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                let wasConnected = self?.isConnected ?? true
                self?.isConnected = (path.status == .satisfied)
                
                // Auto show alert when connection lost (only if it just changed)
                if path.status != .satisfied && wasConnected {
                    self?.showNoInternetAlert()
                }
            }
        }
        monitor.start(queue: DispatchQueue.global())
    }
    
    // Call this in viewDidLoad of each ViewController
    func observe(from vc: UIViewController) {
        currentVC = vc
        
        // Check immediately
        if !isConnected {
            showNoInternetAlert()
        }
    }
    
    // Use this before any action (returns true if connected)
    func checkAndAlert(on vc: UIViewController) -> Bool {
        if isConnected {
            return true
        } else {
            showNoInternetAlert(on: vc)
            return false
        }
    }
    
    private func showNoInternetAlert(on vc: UIViewController? = nil) {
        let targetVC = vc ?? currentVC
        guard let targetVC = targetVC else { return }
        
        // Prevent multiple alerts within 3 seconds
        if let lastTime = lastAlertTime, Date().timeIntervalSince(lastTime) < 3.0 {
            return
        }
        
        // Don't show if already showing an alert
        if isShowingAlert { return }
        
        // Don't show if there's already a presented view controller
        if targetVC.presentedViewController != nil { return }
        
        isShowingAlert = true
        lastAlertTime = Date()
        
        let alert = UIAlertController(
            title: "No Internet",
            message: "Please check your connection and try again.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.isShowingAlert = false
        })
        
        targetVC.present(alert, animated: true)
    }
}
