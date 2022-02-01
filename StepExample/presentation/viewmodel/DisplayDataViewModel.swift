//
//  DisplayDataViewModel.swift
//  StepExample
//
//  Created by ICoon on 01.02.2022.
//

import RxSwift

class DisplayDataViewModel{
    

    fileprivate let repository = Repository()
    
    fileprivate let disposeBag = DisposeBag()
    
    var errorSubject = PublishSubject<String>()
    
    var dataSubject = PublishSubject<[CommentModel]>()
    
    var inProgress = PublishSubject<Bool>()
    
    
    func loadFreshContent(startIndex: Int, endIndex: Int){
        self.repository.loadComments(currentId: startIndex, lastId: endIndex)
            .subscribe { data in
                self.dataSubject.onNext(data)
                self.inProgress.onNext(false)
            } onError: { error in
                self.errorSubject.onNext(error.localizedDescription)
                self.inProgress.onNext(false)
            }.disposed(by: disposeBag)
    }
    
    
}
