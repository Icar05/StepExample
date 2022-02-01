//
//  Repository.swift
//  StepExample
//
//  Created by ICoon on 01.02.2022.
//

import RxSwift


/**
    wrapper layer which handle data souces, local and global
 */
class Repository{
    
    fileprivate let globalProvider = GlobalDataProvider()
    
    /**
            streams are loading asynk, so we have to sort result
     */
    func loadComments(currentId: Int, lastId: Int) -> Observable<[CommentModel]>{
        return globalProvider.loadComments(currentId: currentId, lastId: lastId).map { data in return data.sorted { rM, lM in rM.id < lM.id }
        }
    }
    
}
