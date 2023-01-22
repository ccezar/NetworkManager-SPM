import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?) -> Void

// MARK: Protocols

public protocol NetworkRouter: AnyObject {
    func request(_ endpoint: EndpointType, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

public protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

public protocol URLSessionProtocol {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping NetworkRouterCompletion) -> URLSessionDataTaskProtocol
}

// MARK: Protocols extensions

extension URLSession: URLSessionProtocol {
    public func dataTask(with request: URLRequest,
                  completionHandler: @escaping NetworkRouterCompletion) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

// MARK: Class implementation

public class Router: NetworkRouter {
    
    private var currentTask: URLSessionDataTaskProtocol?
    private let session: URLSessionProtocol

    public init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    public func request(_ endpoint: EndpointType, completion: @escaping NetworkRouterCompletion) {
        do {
            let request = try buildRequest(from: endpoint)
            NetworkLogger.log(request: request)
            currentTask = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        } catch {
            completion(nil, nil, error)
        }
        self.currentTask?.resume()
    }
    
    public func cancel() {
        self.currentTask?.cancel()
    }
    
    fileprivate func buildRequest(from endpoint: EndpointType) throws -> URLRequest {
        var request = URLRequest(url: endpoint.getFullURL(),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        request.httpMethod = endpoint.httpMethod.rawValue
        do {
            switch endpoint.task {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters,
                                    urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
