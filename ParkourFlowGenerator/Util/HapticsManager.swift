//
//  HapticsManager.swift
//  ParkourFlowGenerator
//
//  Created by Steven Sullivan on 11/18/23.
//

import Foundation
import UIKit

final class HapticsManager {
    static let shared = HapticsManager()
    
    private init() {}
    
    public func selectionVibrate() {
        DispatchQueue.main.async {
            let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
            selectionFeedbackGenerator.prepare()
            selectionFeedbackGenerator.selectionChanged()
        }
    }
    
    public func vibrate(for type:UINotificationFeedbackGenerator.FeedbackType) {
        DispatchQueue.main.async {
            let notificationGenerator = UINotificationFeedbackGenerator()
            notificationGenerator.prepare()
            notificationGenerator.notificationOccurred(type)
        }
    }
    
    public func lightVibrate() {
       let generator = UIImpactFeedbackGenerator(style: .light)
       generator.impactOccurred()
    }
    public func mediumVibrate() {
       let generator = UIImpactFeedbackGenerator(style: .medium)
       generator.impactOccurred()
    }
    public func heavyVibrate() {
       let generator = UIImpactFeedbackGenerator(style: .heavy)
       generator.impactOccurred()
    }
}
