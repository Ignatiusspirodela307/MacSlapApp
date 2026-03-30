import AppKit

/// Flashes the screen with a translucent overlay on impact
class ScreenFlash {
    private var flashWindows: [NSWindow] = []

    /// Flash intensity multiplier (0.0 to 2.0, default 1.0)
    var intensityMultiplier: Double = 1.0

    func flash(intensity: Double) {
        let scale = intensity * intensityMultiplier

        for screen in NSScreen.screens {
            let window = NSPanel(
                contentRect: screen.frame,
                styleMask: [.borderless, .nonactivatingPanel],
                backing: .buffered,
                defer: false
            )
            window.level = .screenSaver
            window.backgroundColor = NSColor.white.withAlphaComponent(CGFloat(scale) * 0.5)
            window.isOpaque = false
            window.ignoresMouseEvents = true
            window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
            window.orderFront(nil)

            flashWindows.append(window)

            let duration = 0.15 + (scale * 0.25)
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = duration
                window.animator().alphaValue = 0
            }, completionHandler: {
                window.orderOut(nil)
                self.flashWindows.removeAll { $0 === window }
            })
        }
    }
}
