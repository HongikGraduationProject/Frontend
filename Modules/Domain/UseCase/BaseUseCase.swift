//
//  BaseUseCase.swift
//  UseCase
//
//  Created by choijunios on 8/11/24.
//

import Foundation

import RepositoryInterface
import Entity
import Util

import RxSwift

public protocol UseCaseBase: AnyObject { }

public extension UseCaseBase {
    
    /// Repository로 부터 전달받은 언어레벨의 에러를 도메인 특화 에러로 변경하고, error를 Result의 Failure로, 성공을 Success로 변경합니다.
    func convert<T, F: DomainError>(task: Single<T>) -> Single<Result<T, F>> {
        Single.create { single in
            let disposable = task
                .subscribe { success in
                    single(.success(.success(success)))
                } onFailure: { error in
                    single(.success(.failure(self.toDomainError(error: error))))
                }
            return Disposables.create { disposable.dispose() }
        }
    }
    
    // MARK: InputValidationError
    private func toDomainError<T: DomainError>(error: Error) -> T {

        if let httpError = error as? HTTPResponseException {
            // 서버의 코드값을 특정 도메인 에러로 변경하는 부분
        }
        
        if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
            return T.init(rawValue: "CAP-001")!
        }
        
        return T.undefinedError
    }
}
