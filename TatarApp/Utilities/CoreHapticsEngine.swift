//
//  CoreHapticsEngine.swift
//  TatarApp
//
//  Created by Артем Хлопцев on 05.01.2022.
//

import Foundation
import CoreHaptics

class HapticManager {
    static let instance = HapticManager()
    @Published private var engine: CHHapticEngine?
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }
        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print(error)
        }
    }
    func complexWarning() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            return
        }
            var hapticEvents = [CHHapticEvent]()
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
            hapticEvents.append(event)
        do {
            let pattern = try CHHapticPattern(events: hapticEvents, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print(error)
        }
    }
    func stopHaptics() {
        engine?.stop(completionHandler: { error in
            
        })
    }
}
