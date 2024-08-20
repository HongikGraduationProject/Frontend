//
//  ActionViewController.swift
//  AE
//
//  Created by choijunios on 8/20/24.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import UseCase
import RxCocoa
import RxSwift
import DSKit

enum FetchingResourceType: String, CaseIterable {
    case url
    case text
    
    var identifier: String {
        switch self {
        case .url:
            UTType.url.identifier
        case .text:
            UTType.text.identifier
        }
    }
}

enum FetchResourceError: Error {
    case `default`
}

class ActionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }
    
    public func fetchUrl() -> Single<String> {
        
        guard let item = (self.extensionContext?.inputItems as? [NSExtensionItem])?.first,
              let provider = item.attachments?.first else {
            return .error(FetchResourceError.default)
        }
        
        return Single<String>.create { single in
        
            for item in FetchingResourceType.allCases {
                let identifier = item.identifier
                if provider.hasItemConformingToTypeIdentifier(identifier) {
                        
                    provider.loadItem(forTypeIdentifier: identifier) { (resource, error) in
                        
                        if error != nil {
                            single(.failure(FetchResourceError.default))
                            return
                        }
                        
                        if let url = resource as? URL {
                            single(.success(url.absoluteString))
                            return
                        }
                        
                        if let text = resource as? String {
                            single(.success(text))
                            return
                        }
                    }
                } else {
                    single(.failure(FetchResourceError.default))
                }
            }
            return Disposables.create()
        }
    }
}
