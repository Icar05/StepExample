//
//  MainViewModel.swift
//  StepExample
//
//  Created by ICoon on 01.02.2022.
//

import RxSwift

struct MainModel{
    var content: [CommentModel]
    var lastValue: Int
}

/**
    this viewmodel send actual state to it's views
 */
class MainViewModel{
    
    
    
    fileprivate let repository = Repository()
    
    fileprivate let disposeBag = DisposeBag()
    
    fileprivate var subscription: Disposable?
    
    var errorSubject = PublishSubject<String>()
    
    var dataSubject = PublishSubject<MainModel>()
    
    var inProgress = PublishSubject<Bool>()
        
    
    
    
    func loadContents(startIndex: Int, endIndex: Int){

        if(validIndexes(startIndex: startIndex, endIndex: endIndex)){
            self.inProgress.onNext(true)
            self.subscription = self.repository.loadComments(currentId: startIndex, lastId: endIndex)
                .subscribe { data in
                    let model = MainModel(content: data, lastValue: endIndex)
                    self.dataSubject.onNext(model)
                    self.inProgress.onNext(false)
                } onError: { error in
                    self.errorSubject.onNext(error.localizedDescription)
                    self.inProgress.onNext(false)
                } onDisposed: {
                    self.inProgress.onNext(false)
                }
                
            self.subscription?.disposed(by: disposeBag)
        }
    }
    
    func cancelRequest(){
        self.subscription?.dispose()
    }
    
    
    private func validIndexes(startIndex: Int, endIndex: Int) -> Bool{
        if(startIndex > endIndex ){
            self.errorSubject.onNext("end index should be bigger then start index")
            return false
        }
        
        if(endIndex > maxIndexValue){
            self.errorSubject.onNext("end value \(endIndex) can't be more than \(maxIndexValue)")
            return false
        }
        
        return true
    }
    
}
