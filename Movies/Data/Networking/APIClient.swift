//
//  APIClient.swift
//  Movies
//
//  Created by Mahmoud Elshakoushy on 27/05/2024.
//

import Combine
import Foundation

// MARK: API Client

public protocol APIClient {
    associatedtype EndpointType: APIEndpoint
    func request<T: Decodable>(_ endpoint: EndpointType) -> AnyPublisher<T, Error>
}

// MARK: - URL Session

public protocol URLSessionProtocol {
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
}

extension URLSession: URLSessionProtocol {}

public class URLSessionAPIClient<EndpointType: APIEndpoint>: APIClient {
    private var session: URLSessionProtocol

    // MARK: - Init

    public init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    // MARK: - Request

    public func request<T: Decodable>(_ endpoint: EndpointType) -> AnyPublisher<T, Error> {
        let request = createRequest(endpoint)
        return session.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }

                guard (200 ... 299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error -> Error in
                if let decodingError = error as? DecodingError {
                    return decodingError
                } else if let urlError = error as? URLError {
                    return urlError
                } else {
                    return error
                }
            }
            .eraseToAnyPublisher()
    }

    // MARK: - Private Methods

    private func createRequest(_ endpoint: EndpointType) -> URLRequest {
        let url = endpoint.baseURL.appendingPathComponent(endpoint.path)
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        endpoint.headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        return request
    }
}
