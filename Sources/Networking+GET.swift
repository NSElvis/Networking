import Foundation

public extension Networking {

    /**
     GET request to the specified path.
     - parameter path: The path for the GET request.
     - parameter completion: A closure that gets called when the GET request is completed, it contains a `JSON` object and an `NSError`.
     - returns: The request identifier.
     */
    @discardableResult
    public func GET(_ path: String, parameters: Any? = nil, completion: @escaping (_ JSON: Any?, _ error: NSError?) -> Void) -> String {
        let parameterType = parameters != nil ? ParameterType.formURLEncoded : ParameterType.none
        let requestID = self.request(.GET, path: path, parameterType: parameterType, parameters: parameters, parts: nil, responseType: .json) { JSON, headers, error in
            completion(JSON, error)
        }

        return requestID
    }

    /**
     GET request to the specified path.
     - parameter path: The path for the GET request.
     - parameter completion: A closure that gets called when the GET request is completed, it contains a `JSON` object and an `NSError`.
     - returns: The request identifier.
     */
    @discardableResult
    public func GET(_ path: String, parameters: Any? = nil, completion: @escaping (_ JSON: Any?, _ headers: [AnyHashable: Any], _ error: NSError?) -> Void) -> String {
        let parameterType = parameters != nil ? ParameterType.formURLEncoded : ParameterType.none
        let requestID = self.request(.GET, path: path, parameterType: parameterType, parameters: parameters, parts: nil, responseType: .json, completion: completion)

        return requestID
    }

    /**
     Registers a fake GET request for the specified path. After registering this, every GET request to the path, will return the registered response.
     - parameter path: The path for the faked GET request.
     - parameter response: An `Any` that will be returned when a GET request is made to the specified path.
     - parameter statusCode: By default it's 200, if you provide any status code that is between 200 and 299 the response object will be returned, otherwise we will return an error containig the provided status code.
     */
    public func fakeGET(_ path: String, response: Any?, statusCode: Int = 200) {
        self.fake(.GET, path: path, response: response, responseType: .json, statusCode: statusCode)
    }

    /**
     Registers a fake GET request for the specified path using the contents of a file. After registering this, every GET request to the path, will return the contents of the registered file.
     - parameter path: The path for the faked GET request.
     - parameter fileName: The name of the file, whose contents will be registered as a reponse.
     - parameter bundle: The NSBundle where the file is located.
     */
    public func fakeGET(_ path: String, fileName: String, bundle: Bundle = Bundle.main) {
        self.fake(.GET, path: path, fileName: fileName, bundle: bundle)
    }

    /**
     Cancels the GET request for the specified path. This causes the request to complete with error code URLError.cancelled.
     - parameter path: The path for the cancelled GET request
     */
    public func cancelGET(_ path: String) {
        let url = try! self.url(for: path)
        self.cancelRequest(.data, requestType: .GET, url: url)
    }
}
