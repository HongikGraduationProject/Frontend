//
//  BaseService.swift
//  DataSource
//
//  Created by choijunios on 8/9/24.
//

import Foundation

import Entity
import Util

import Moya
import RxMoya
import Alamofire
import RxSwift

public class BaseNetworkService<TagetAPI: BaseAPI> {
    
    private lazy var providerWithToken: MoyaProvider<TagetAPI> = {
        
        let provider = MoyaProvider<TagetAPI>(session: sessionWithToken)
        
        return provider
    }()
    
    private lazy var providerWithoutToken: MoyaProvider<TagetAPI> = {
        
        let provider = MoyaProvider<TagetAPI>(session: sessionWithoutToken)
        
        return provider
    }()
    
    lazy var sessionWithToken: Session = {
        
        let configuration = URLSessionConfiguration.default
        
        // 단일 요청이 완료되는데 걸리는 최대 시간, 초과시 타임아웃
        configuration.timeoutIntervalForRequest = 10
        
        // 하나의 리소스를 로드하는데 걸리는 시간, 재시도를 포함한다 초과시 타임아웃
        configuration.timeoutIntervalForResource = 10
        
        // Cache policy: 로컬캐시를 무시하고 항상 새로운 데이터를 가져온다.
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        let tokenIntercepter = Interceptor.interceptor(
            adapter: tokenAdpater,
            retrier: tokenRetrier
        )
        
        return Session(
            configuration: configuration,
            interceptor: tokenIntercepter
        )
    }()
    
    // Token을 요구하지 않는 요청에서 사용됩니다.
    let sessionWithoutToken: Session = {
       
        let configuration = URLSessionConfiguration.default
        
        // 단일 요청이 완료되는데 걸리는 최대 시간, 초과시 타임아웃
        configuration.timeoutIntervalForRequest = 10
        
        // 하나의 리소스를 로드하는데 걸리는 시간, 재시도를 포함한다 초과시 타임아웃
        configuration.timeoutIntervalForResource = 10
        
        // Cache policy: 로컬캐시를 무시하고 항상 새로운 데이터를 가져온다.
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        return Session(configuration: configuration)
    }()
    
    // 요청을 보내기 전에 토큰을 어뎁팅합니다.
    lazy var tokenAdpater = Adapter { [weak self] request, session, completion in
        
        var adaptedRequest = request
        
        if let accessToken: String = UserDefaultsDataSource.shared.fetchData(key: .accessToken) {
            
            let bearerToken = "Bearer \(accessToken)"
            
            adaptedRequest.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        }
          
        completion(.success(adaptedRequest))
    }
    
    private let tokenSession: Session = {
       
        let configuration = URLSessionConfiguration.default
        
        // 단일 요청이 완료되는데 걸리는 최대 시간, 초과시 타임아웃
        configuration.timeoutIntervalForRequest = 10
        
        // 하나의 리소스를 로드하는데 걸리는 시간, 재시도를 포함한다 초과시 타임아웃
        configuration.timeoutIntervalForResource = 10
        
        // Cache policy: 로컬캐시를 무시하고 항상 새로운 데이터를 가져온다.
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        let session = Session(configuration: configuration)
        
        return session
    }()
    
    lazy var tokenRetrier = Retrier { [weak self, sessionWithoutToken] request, session, error, completion in
        
        if let httpResponse = request.response {
            
            if httpResponse.statusCode == 401, let imei: String = UserDefaultsDataSource.shared.fetchData(key: .imei) {
                
                let tokenProvider = MoyaProvider<AuthAPI>(session: sessionWithoutToken)
                
                tokenProvider
                    .request(.issueAccessToken(imei: imei)) { [weak self] result in
                        
                        switch result {
                        case .success(let response):
                            if let accessToken = try? JSONDecoder().decode(CAPResponse<TokenDTO>.self, from: response.data).data?.accessToken {
                                
                                // accessToken토큰 저장
                                UserDefaultsDataSource.shared.saveData(key: .accessToken, value: accessToken)

                                completion(.retry)
                            } else {
                                completion(.doNotRetry)
                            }
                        case .failure(let error):
                            completion(.doNotRetryWithError(error))
                        }
                    }
                
            } else {
                completion(.doNotRetry)
            }
        }
    }
    
    public init() { }
}

// MARK: DataRequest
public extension BaseNetworkService {
    
    enum RequestType {
        case plain
        case withToken
    }
    
    private func _request(api: TagetAPI, provider: MoyaProvider<TagetAPI>) -> Single<Response> {
        
        provider.rx
            .request(api)
            .catch { [weak self] error in
                if let moyaError = error as? MoyaError, let httpError = self?.responseToHTTPError(error: moyaError) {
                    return .error(httpError)
                }
                return .error(error)
            }
    }
    
    func request(api: TagetAPI, with: RequestType) -> Single<Response> {
        
        _request(
            api: api,
            provider: with == .plain ? self.providerWithoutToken : self.providerWithToken
        )
    }
    
    func requestDecodable<T: Decodable>(api: TagetAPI, with: RequestType) -> Single<T> {
        
        request(api: api, with: with)
            .map(T.self)
    }
    
    func responseToHTTPError(error: MoyaError) -> HTTPResponseException? {
        var response: Response?
        
        if case let .underlying(_, res) = error { response = res }
        if case let .statusCode(res) = error { response = res }
        
        if let response {
            return HTTPResponseException(response: response)
        }
        return nil
    }
    
    func requestDecodable<T: Decodable>(api: TagetAPI, with: RequestType) async throws -> T {
        let url = api.baseURL.appending(path: api.path)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = api.method.rawValue
        
        api.headers?.forEach({ (key: String, value: String) in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        })
        
        if with == .withToken, let accessToken: String = UserDefaultsDataSource.shared.fetchData(key: .accessToken) {
            let bearerToken = "Bearer \(accessToken)"
            urlRequest.setValue(bearerToken, forHTTPHeaderField: "Authorization")
        }
        
        do {
            let (data, respose) = try await URLSession.shared.data(for: urlRequest)
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            
            if let moyaError = error as? MoyaError, let httpError = responseToHTTPError(error: moyaError) {
                throw httpError
            }
            
            if let decodingError = error as? DecodingError {
                #if DEBUG
                print("\(#function) 디코딩 에러")
                #endif
                
                throw decodingError
            }
            
            throw error
        }
    }
}

// MARK: HTTPResponseException+Extension
extension HTTPResponseException {
    
    /// 전달받은 에러 응답을 바탕으로,ErrorDTO로 디코딩 합니다.
    init(response: Response) {
        
        let status: HttpResponseStatus = .create(code: response.statusCode)
        var message: String? = nil
        
        if let decodedError = try? JSONDecoder().decode(ErrorDTO.self, from: response.data) {
            if let errorMessage = decodedError.message { message = errorMessage }
        }
        self.init(
            status: status,
            message: message
        )
    }
}
