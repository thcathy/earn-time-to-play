import ActivityKit
import Foundation

enum TimerLiveActivityManager {
  /// Remaining time must stay under 1 hour or iOS renders seconds as "--".
  private static let secondsVisibleWindow: TimeInterval = 50 * 60
  private static var gate: Task<Void, Never> = Task {}

  static func start(arguments: Any?, result: @escaping (Bool) -> Void) {
    guard #available(iOS 16.1, *) else {
      reply(result, false)
      return
    }
    guard ActivityAuthorizationInfo().areActivitiesEnabled else {
      reply(result, false)
      return
    }

    let args = arguments as? [String: Any] ?? [:]
    let mode = args["mode"] as? String ?? "focus"
    let title = args["title"] as? String ?? "Timer"
    let startedAtMillis: Int64
    if let value = args["startedAtMillis"] as? NSNumber {
      startedAtMillis = value.int64Value
    } else {
      startedAtMillis = Int64(Date().timeIntervalSince1970 * 1000)
    }
    let startedAt = Date(timeIntervalSince1970: TimeInterval(startedAtMillis) / 1000.0)

    Task {
      let started = await serialized {
        await upsert(mode: mode, title: title, startedAt: startedAt)
      }
      reply(result, started)
    }
  }

  static func end(result: @escaping (Bool) -> Void) {
    guard #available(iOS 16.1, *) else {
      reply(result, true)
      return
    }
    Task {
      _ = await serialized {
        await endAll()
        return true
      }
      reply(result, true)
    }
  }

  private static func reply(_ result: @escaping (Bool) -> Void, _ value: Bool) {
    if Thread.isMainThread {
      result(value)
    } else {
      DispatchQueue.main.async { result(value) }
    }
  }

  private static func serialized<T: Sendable>(
    _ work: @escaping @Sendable () async -> T
  ) async -> T {
    let previous = gate
    let current = Task<T, Never> {
      await previous.value
      return await work()
    }
    gate = Task { _ = await current.value }
    return await current.value
  }

  @available(iOS 16.1, *)
  private static func upsert(mode: String, title: String, startedAt: Date) async -> Bool {
    let state = TimerActivityAttributes.ContentState(
      startedAt: startedAt,
      displayUntil: Date().addingTimeInterval(secondsVisibleWindow)
    )
    let activities = Array(Activity<TimerActivityAttributes>.activities)
    let matching = activities.first { $0.attributes.mode == mode }

    if let matching {
      await endAll(except: matching.id)
      await update(matching, state: state)
      return true
    }

    await endAll()

    do {
      try request(mode: mode, title: title, state: state)
      return true
    } catch {
      return false
    }
  }

  @available(iOS 16.1, *)
  private static func request(
    mode: String,
    title: String,
    state: TimerActivityAttributes.ContentState
  ) throws {
    let attributes = TimerActivityAttributes(mode: mode, title: title)
    if #available(iOS 16.2, *) {
      _ = try Activity.request(
        attributes: attributes,
        content: ActivityContent(state: state, staleDate: nil),
        pushType: nil
      )
    } else {
      _ = try Activity.request(attributes: attributes, contentState: state, pushType: nil)
    }
  }

  @available(iOS 16.1, *)
  private static func endAll(except keepId: String? = nil) async {
    for activity in Activity<TimerActivityAttributes>.activities where activity.id != keepId {
      await end(activity)
    }
  }

  @available(iOS 16.1, *)
  private static func update(
    _ activity: Activity<TimerActivityAttributes>,
    state: TimerActivityAttributes.ContentState
  ) async {
    if #available(iOS 16.2, *) {
      await activity.update(ActivityContent(state: state, staleDate: nil))
    } else {
      await activity.update(using: state)
    }
  }

  @available(iOS 16.1, *)
  private static func end(_ activity: Activity<TimerActivityAttributes>) async {
    if #available(iOS 16.2, *) {
      await activity.end(nil, dismissalPolicy: .immediate)
    } else {
      await activity.end(dismissalPolicy: .immediate)
    }
  }
}
