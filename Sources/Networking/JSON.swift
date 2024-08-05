import Foundation

/// The ParsingError codes generated by JSON.
enum ParsingError: Error {
    case notFound
}

enum JSON: Equatable {
    case none(Data)

    case dictionary(Data, [String: Any])

    case array(Data, [[String: Any]])

    var dictionary: [String: Any] {
        switch self {
        case let .dictionary(_, body):
            return body
        default:
            return [String: Any]()
        }
    }

    var array: [[String: Any]] {
        switch self {
        case let .array(_, body):
            return body
        default:
            return [[String: Any]]()
        }
    }

    var data: Data {
        switch self {
        case let .dictionary(data, _):
            return data
        case let .array(data, _):
            return data
        case let .none(data):
            return data
        }
    }

    init(_ data: Data) throws {
        let body = try JSONSerialization.jsonObject(with: data, options: [])

        if let dictionary = body as? [String: Any] {
            self = .dictionary(data, dictionary)
        } else if let array = body as? [[String: Any]] {
            self = .array(data, array)
        } else {
            self = .none(data)
        }
    }

    init(_ dictionary: [String: Any]) throws {
        let data = try JSONSerialization.data(withJSONObject: dictionary, options: [])

        self = .dictionary(data, dictionary)
    }

    init(_ array: [[String: Any]]) throws {
        let data = try JSONSerialization.data(withJSONObject: array, options: [])

        self = .array(data, array)
    }
}

public extension FileManager {
    /// Returns a JSON object from a file.
    ///
    /// - Parameters:
    ///   - fileName: The name of the file, the expected extension is `.json`.
    ///   - bundle: The Bundle where the file is located, by default is the main bundle.
    /// - Returns: A JSON object, it can be either a Dictionary or an Array.
    /// - Throws: An error if it wasn't able to process the file.
    static func json(from fileName: String, bundle: Bundle = Bundle.main) throws -> Any? {
        var json: Any?

        guard let url = URL(string: fileName), let filePath = bundle.path(forResource: url.deletingPathExtension().absoluteString, ofType: url.pathExtension) else { throw ParsingError.notFound }
        let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
        json = try data.toJSON()

        return json
    }
}

func ==(lhs: JSON, rhs: JSON) -> Bool {
    return lhs.array.debugDescription == rhs.array.debugDescription && lhs.dictionary.debugDescription == rhs.dictionary.debugDescription
}

extension Data {

    /// Serializes Data into a JSON object.
    ///
    /// - Returns: A JSON object, it can be either a Dictionary or an Array.
    /// - Throws: An error if it couldn't serialize the data into json.
    public func toJSON() throws -> Any? {
        return try JSONSerialization.jsonObject(with: self, options: [])
    }
}
