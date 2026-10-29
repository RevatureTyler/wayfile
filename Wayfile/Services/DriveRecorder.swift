import CoreLocation
import Observation
import SwiftData

/// Records one drive at a time from GPS updates. Milestone 0: you press Start and Stop.
/// Automatic detection comes in milestone 1.
@MainActor
@Observable
final class DriveRecorder: NSObject, CLLocationManagerDelegate {
    private(set) var isRecording = false
    private(set) var distanceMeters: Double = 0
    private(set) var startedAt: Date?
    private(set) var authorization: CLAuthorizationStatus = .notDetermined

    @ObservationIgnored private let manager = CLLocationManager()
    @ObservationIgnored private var lastLocation: CLLocation?

    /// Drives shorter than this are discarded (about 0.1 mile).
    static let minimumDistanceMeters: Double = 160

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.activityType = .automotiveNavigation
        manager.pausesLocationUpdatesAutomatically = false
        authorization = manager.authorizationStatus
    }

    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }

    func start() {
        guard !isRecording else { return }
        if authorization == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
        distanceMeters = 0
        lastLocation = nil
        startedAt = Date()
        isRecording = true
        manager.allowsBackgroundLocationUpdates = true
        manager.showsBackgroundLocationIndicator = true
        manager.startUpdatingLocation()
    }

    /// Stops recording and saves the drive if it was long enough. Returns the saved drive.
    @discardableResult
    func stop(into context: ModelContext) -> Drive? {
        guard isRecording, let startedAt else { return nil }
        manager.stopUpdatingLocation()
        manager.allowsBackgroundLocationUpdates = false
        isRecording = false
        self.startedAt = nil

        guard distanceMeters >= Self.minimumDistanceMeters else { return nil }
        let drive = Drive(startedAt: startedAt, endedAt: Date(), distanceMeters: distanceMeters)
        context.insert(drive)
        return drive
    }

    private func handle(_ locations: [CLLocation]) {
        guard isRecording else { return }
        for location in locations where location.horizontalAccuracy >= 0 && location.horizontalAccuracy <= 50 {
            if let last = lastLocation {
                let step = location.distance(from: last)
                if step >= 5 {
                    distanceMeters += step
                    lastLocation = location
                }
            } else {
                lastLocation = location
            }
        }
    }

    // MARK: CLLocationManagerDelegate

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        Task { @MainActor in
            self.authorization = status
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task { @MainActor in
            self.handle(locations)
        }
    }
}
