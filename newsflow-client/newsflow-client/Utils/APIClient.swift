//
//  APIClient.swift
//  newsflow-client
//
//  Created by Yazan Ghunaim on 4/4/25.
//

import Alamofire
import Foundation

// MARK: - empty json response
struct EmptyEntity: Codable, EmptyResponse {

    static func emptyValue() -> EmptyEntity {
        return EmptyEntity.init()
    }
}

// MARK: - APIError Enum
enum APIError: Error {
    case invalidURL
    case decodingError(Error)
    case unauthorized
    case conflict
    case serverError(statusCode: Int)
    case unknown(Error)
}

final class APILogger: EventMonitor {
    func requestDidFinish(_ request: Request) {
        NFLogger.shared.logger.debug("➡️ Request: \(request.description)")
    }

    //    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
    //        NFLogger.shared.logger.debug("⬅️ Response: \(response.description)")
    //    }
}

final class AuthInterceptor: RequestInterceptor {
    private let getToken: @Sendable () -> String?

    init(getToken: @escaping @Sendable () -> String?) {
        self.getToken = getToken
    }

    func adapt(
        _ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var request = urlRequest
        if let accToken = getToken() {
            request.setValue("Bearer \(accToken)", forHTTPHeaderField: "Authorization")

            // add empty refresh-token value if not passed
            if request.value(forHTTPHeaderField: "refresh-token") == nil {
                request.setValue("", forHTTPHeaderField: "refresh-token")
            }
        }
        completion(.success(request))
    }
}

// MARK: - APIClient
class APIClient {
    static let shared = APIClient()

    private let session: Session

    private init() {
        let interceptor = AuthInterceptor {
            KeychainManager.shared.getToken(forKey: .userAccessToken)
        }

        let logger = APILogger()

        self.session = Session(interceptor: interceptor, eventMonitors: [logger])
    }

    func request<T: Decodable, B: Encodable>(
        url: String,
        method: HTTPMethod = .get,
        body: B? = nil as EmptyEntity?,
        headers: HTTPHeaders? = nil,
        withRefreshToken: Bool = false
    ) async -> Result<T, APIError> {
        guard let url = URL(string: url) else {
            return .failure(.invalidURL)
        }

        do {
            var urlRequest = try URLRequest(url: url, method: method, headers: headers)
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

            // add refresh-token header on request
            if withRefreshToken {
                urlRequest.setValue(
                    KeychainManager.shared.getToken(forKey: .userRefreshToken)!,
                    forHTTPHeaderField: "refresh-token"
                )
            }

            if let body = body {
                let jsonData = try JSONEncoder().encode(body)
                urlRequest.httpBody = jsonData
            }

            let response = try await session.request(urlRequest)
                .validate()
                .serializingDecodable(T.self)
                .value

            return .success(response)

        } catch let error as DecodingError {
            return .failure(.decodingError(error))
        } catch let error as AFError {
            if let statusCode = error.responseCode {
                switch statusCode {
                case 401:
                    return .failure(.unauthorized)
                case 409:
                    return .failure(.conflict)
                default:
                    return .failure(.serverError(statusCode: statusCode))
                }
            }
            return .failure(.unknown(error))
        } catch {
            return .failure(.unknown(error))
        }
    }
}
