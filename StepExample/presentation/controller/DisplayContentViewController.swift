//
//  DisplayContentViewController.swift
//  StepExample
//
//  Created by ICoon on 01.02.2022.
//

import UIKit
import RxSwift
import UIScrollView_InfiniteScroll

class DisplayContentViewController: UIViewController {
    
    
    
    
    fileprivate let viewModel = DisplayDataViewModel()
    
    fileprivate let disposeBag = DisposeBag()
    
    var dataSource: [CommentModel] = []
    
    var lastValue = 0
    
    var currentValue = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.rowHeight = tableViewRowHeight
        self.tableView.addInfiniteScroll { [self] (tableView) -> Void in
            self.viewModel.loadFreshContent(startIndex: self.currentValue, endIndex: lastValue)
        }
        
        
        self.viewModel
            .errorSubject
            .subscribe(onNext: {[weak self] in
                self?.handleErrors(error: $0)
            })
            .disposed(by: disposeBag)
        
        
        self.viewModel
            .inProgress
            .subscribe(onNext: {[weak self] in
                self?.finishRefresh(value: $0)
            })
            .disposed(by: disposeBag)
        
        self.viewModel
            .dataSubject
            .subscribe(onNext: {[weak self] in
                self?.dataSource.append(contentsOf: $0)
                self?.currentValue = (self?.dataSource.last!.id)! + 1
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
}

extension DisplayContentViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Step", for: indexPath) as! CustomCell
        cell.setup(model: dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewRowHeight
    }
    
    func finishRefresh(value: Bool){
        self.tableView.finishInfiniteScroll()
    }
    
    func handleErrors(error: String){
        
        let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
