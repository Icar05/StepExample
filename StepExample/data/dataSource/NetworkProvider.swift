//
//  NetworkProvider.swift
//  StepExample
//
//  Created by ICoon on 31.01.2022.
//

import RxSwift
import Alamofire

/**
    simple helper util to network queries
     
 */
class NetworkProvider{
    
    let decoder = JSONDecoder()
    
    let baseUrl = "https://jsonplaceholder.typicode.com/"
    
    
    func loadComment(commentId: Int) -> Observable<CommentModel>{
        
        return Observable<CommentModel>.create { (observer) -> Disposable in
            let dataRequest = Session.default.request(self.baseUrl+"comments/\(commentId)")
                .validate()
                .responseJSON { (response) in
                    switch response.result {
                    case .success:
                        do {
                            let model = try self.decoder.decode(CommentModel.self, from:response.data!)
                            observer.onNext(model)
                        } catch {
                            observer.onError(error)
                        }
                    case .failure:
                        observer.onError(response.error!)
                    }
                    
                    observer.onCompleted()
                }
            
            return Disposables.create {
                dataRequest.cancel()
            }
        }
    }
    
}
