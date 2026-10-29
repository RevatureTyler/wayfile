import Foundation
import SwiftData

enum DriveStatus: String, CaseIterable, Identifiable {
    case unclassified, business, personal

    var id: String { rawValue }

    var title: String {
        switch self {
        case .unclassified: "Unclassified"
        case .business: "Business"
        case .personal: "Personal"
        }
    }

    var symbol: String {
        switch self {
        case .unclassified: "questionmark.circle"
        case .business: "briefcase.fill"
        case .personal: "person.fill"
        }
    }
}

@Model
final class Drive {
    var clientID: UUID
    var startedAt: Date
    var endedAt: Date
    var distanceMeters: Double
    var statusRaw: String
    var category: String
    var purpose: String
    var notes: String
    var source: String

    var status: DriveStatus {
        get { DriveStatus(rawValue: statusRaw) ?? .unclassified }
        set { statusRaw = newValue.rawValue }
    }

    init(
        startedAt: Date,
        endedAt: Date,
        distanceMeters: Double,
        status: DriveStatus = .unclassified,
        source: String = "recorded"
    ) {
        self.clientID = UUID()
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.distanceMeters = distanceMeters
        self.statusRaw = status.rawValue
        self.category = ""
        self.purpose = ""
        self.notes = ""
        self.source = source
    }
}
