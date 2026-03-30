import Foundation
import AppKit

/// Triggers haptic feedback on the MacBook's trackpad.
/// Uses NSHapticFeedbackManager — fires multiple taps for stronger intensity.
class HapticFeedback {
    /// Haptic intensity multiplier (0.0 to 2.0, default 1.0)
    var intensityMultiplier: Double = 1.0

    init() {
        log("Trackpad Haptic Feedback: Using NSHapticFeedbackManager")
    }

    /// Fire the Taptic Engine
    func buzz(intensity: Double) {
        let scale = intensity * intensityMultiplier

        DispatchQueue.main.async {
            let performer = NSHapticFeedbackManager.defaultPerformer

            if scale > 0.8 {
                // Strong: triple tap
                performer.perform(.generic, performanceTime: .now)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.04) {
                    performer.perform(.generic, performanceTime: .now)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                    performer.perform(.generic, performanceTime: .now)
                }
            } else if scale > 0.5 {
                // Medium: double tap
                performer.perform(.generic, performanceTime: .now)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    performer.perform(.generic, performanceTime: .now)
                }
            } else if scale > 0.2 {
                // Light: single generic
                performer.perform(.generic, performanceTime: .now)
            } else {
                // Very light: alignment (softest available)
                performer.perform(.alignment, performanceTime: .now)
            }
        }
    }
}
