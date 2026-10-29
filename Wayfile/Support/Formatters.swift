import Foundation

private let metersPerMile = 1609.344

func miles(_ meters: Double) -> String {
    String(format: "%.1f mi", meters / metersPerMile)
}

func elapsed(since start: Date, now: Date) -> String {
    let seconds = max(0, Int(now.timeIntervalSince(start)))
    let hours = seconds / 3600
    let minutes = (seconds % 3600) / 60
    let secs = seconds % 60
    return hours > 0
        ? String(format: "%d:%02d:%02d", hours, minutes, secs)
        : String(format: "%d:%02d", minutes, secs)
}
