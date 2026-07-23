import Foundation

/// Logging levels for Libgnss_Coding
///
/// Use these levels to filter the verbosity of the library's diagnostic output.
public enum GNSSLogLevel: Int, Comparable {
    case none = 0
    case error = 1
    case warn = 2
    case info = 3
    case debug = 4
    case trace = 5
    
    public static func < (lhs: GNSSLogLevel, rhs: GNSSLogLevel) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

/// A thread-safe, callback-based logger to match libgnss-coding's functionality.
///
/// Use the `shared` instance to configure the library's logging behavior.
public final class GNSSLogger: @unchecked Sendable {
    public typealias LogCallback = @Sendable (GNSSLogLevel, String) -> Void
    
    public static let shared = GNSSLogger()
    
    private let lock = NSLock()
    private var _logLevel: GNSSLogLevel = .error
    private var _callback: LogCallback?

    public var logLevel: GNSSLogLevel {
        get {
            lock.lock()
            defer { lock.unlock() }
            return _logLevel
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            _logLevel = newValue
        }
    }

    public var callback: LogCallback? {
        get {
            lock.lock()
            defer { lock.unlock() }
            return _callback
        }
        set {
            lock.lock()
            defer { lock.unlock() }
            _callback = newValue
        }
    }
    
    private init() {}
    
    public func log(_ level: GNSSLogLevel, _ message: String) {
        lock.lock()
        let currentLogLevel = _logLevel
        let currentCallback = _callback
        lock.unlock()

        guard level <= currentLogLevel, let callback = currentCallback else { return }
        callback(level, message)
    }
    
    public func error(_ message: String) { log(.error, message) }
    public func warn(_ message: String) { log(.warn, message) }
    public func info(_ message: String) { log(.info, message) }
    public func debug(_ message: String) { log(.debug, message) }
    public func trace(_ message: String) { log(.trace, message) }
}

// Internal logging helpers
func GNSS_LOGE(_ message: String) { GNSSLogger.shared.error(message) }
func GNSS_LOGW(_ message: String) { GNSSLogger.shared.warn(message) }
func GNSS_LOGI(_ message: String) { GNSSLogger.shared.info(message) }
func GNSS_LOGD(_ message: String) { GNSSLogger.shared.debug(message) }
func GNSS_LOGT(_ message: String) { GNSSLogger.shared.trace(message) }
