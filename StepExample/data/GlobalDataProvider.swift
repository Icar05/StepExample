//
//  GlobalDataProvider.swift
//  StepExample
//
//  Created by ICoon on 31.01.2022.
//

import RxSwift


/**
    data layer which  updated network queries to our task
 */
class GlobalDataProvider{
    
    
    private let networkSoure = NetworkProvider()
    
    
    /*
        prepare values to offset:
     - predicate last index - us current value + offset
     - last value - real last value which we can use consider allowed last index
     */
    func loadComments(currentId: Int, lastId: Int) -> Observable<[CommentModel]>{
        
        if(currentId >= lastId){
            return Observable.error(prepareError(error: "All fresh data has allready loaded"))
        }
        
        let predictedLastIndex = currentId + (offset - 1)
        let lastIndex = predictedLastIndex < lastId ? predictedLastIndex: lastId
        let ids = Array(currentId...lastIndex)
        
        return Observable.from(ids)
            .delay(.seconds(loadingDelay), scheduler: MainScheduler.instance)
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMap { id in self.networkSoure.loadComment(commentId: id)}
            .toArray()
            .asObservable()
            .observe(on: MainScheduler.instance)
                
    }
    
    /**
            wrapper to handle error
     */
    private func prepareError(error: String) ->  NSError{
        let userInfo = [NSLocalizedDescriptionKey : error]
        return NSError(domain: "", code: 0, userInfo: userInfo)
    }
    
}
