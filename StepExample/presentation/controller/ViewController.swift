//
//  ViewController.swift
//  StepExample
//
//  Created by ICoon on 31.01.2022.
//

import UIKit
import RxSwift




class ViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var indexView: IndexView!
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var mainLabel: UILabel!
    
    fileprivate let viewModel = MainViewModel()
    
    fileprivate let disposeBag = DisposeBag()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        self.disableKeyboardByClick()
        
        self.viewModel
            .errorSubject
            .subscribe(onNext: {[weak self] in
                self?.drawErrors(error: $0)
            })
            .disposed(by: disposeBag)
        
        
        self.viewModel
            .inProgress
            .subscribe(onNext: {[weak self] in
                self?.showProgress(value: $0)
            })
            .disposed(by: disposeBag)
        
        self.viewModel
            .dataSubject
            .subscribe(onNext: {[weak self] in
                self?.handleResults(data: $0)
            })
            .disposed(by: disposeBag)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ViewController: IndexViewDelegate{
    
    func onCancel() {
        self.viewModel.cancelRequest()
    }
    
    func onIndexesFound(firstIndes: Int, lastIndex: Int) {
        self.clearErrors()
        self.view.endEditing(true)
        self.viewModel.loadContents(startIndex: firstIndes, endIndex: lastIndex)
    }
    
    func clearErrors(){
        self.mainLabel.text = "Select start and end ids"
        self.mainLabel.textColor = .black
    }
    
    func drawErrors(error: String){
        self.mainLabel.text = error
        self.mainLabel.textColor = .red
    }
    
    
    func disableKeyboardByClick(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        self.indexView.delegate = self
    }
    
    func showProgress(value: Bool){
        value ? indicator.startAnimating(): indicator.stopAnimating()
        
        let state = value ? ButtonState.canceled : ButtonState.loading
        self.indexView.setButtonState(state: state)
    }
    
    func handleResults(data: MainModel){
        let next = self.storyboard?.instantiateViewController(withIdentifier: "DisplayContentViewController") as! DisplayContentViewController
        next.dataSource.append(contentsOf: data.content)
        next.currentValue = data.content.last!.id + 1
        next.lastValue = data.lastValue
        self.navigationController?.pushViewController(next, animated: true)
    }
    
}
