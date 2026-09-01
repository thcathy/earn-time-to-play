import ActivityKit
import Foundation

struct TimerActivityAttributes: ActivityAttributes {
  var mode: String
  var title: String

  struct ContentState: Codable, Hashable {
    var startedAt: Date
    var displayUntil: Date
  }
}
