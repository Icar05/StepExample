//
//  IndexView.swift
//  StepExample
//
//  Created by ICoon on 01.02.2022.
//

import UIKit


struct ButtonPrefs{
    var color: UIColor
    var text: String
}

public enum ButtonState{
    case loading, canceled
}

protocol IndexViewDelegate : AnyObject {
    func onIndexesFound(firstIndes: Int, lastIndex: Int)
    func onCancel()
}


/**
 this view collect values from textfield and push them to controller
 
 it can change button's view, there are 2 states, for loading and for canceling
 */
@IBDesignable
class IndexView: UIView{
    
    
    
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var startIdTF: UITextField!
    
    @IBOutlet weak var endIdTF: UITextField!
    
    @IBOutlet weak var loadBtn: UIButton!
    
    
    let buttonPreferences = [
        ButtonState.canceled: ButtonPrefs(color: UIColor.red, text: "Cancel!"),
        ButtonState.loading: ButtonPrefs(color: UIColor.blue, text: "Load"),
    ]
    
    
    weak var delegate: IndexViewDelegate? = nil
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareView()
    }
    
    
    func prepareView(){
        
        let bundle = Bundle(for: IndexView.self)
        bundle.loadNibNamed(String(describing: IndexView.self), owner: self, options: nil)
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask =
        [UIView.AutoresizingMask.flexibleWidth,
         UIView.AutoresizingMask.flexibleHeight]
        
        self.translatesAutoresizingMaskIntoConstraints = true
        self.layer.masksToBounds = true
        
        self.setupSelectors()
        self.setButtonState(state: .loading)
        self.loadBtn.isEnabled = false
    }
    
    
    private func setupSelectors(){
        self.startIdTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        self.endIdTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        self.loadBtn.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
    }
    
    
    /**
     tup should be handled align to current state:
     if it's loading - tap should grab data
     otherwise it send cancel
     */
    @objc func buttonClicked(){
        if(getButtonState() == .loading){
            let firstIndex = Int(self.startIdTF.text!)!
            let secondIndex = Int(self.endIdTF.text!)!
            self.delegate?.onIndexesFound(firstIndes: firstIndex, lastIndex: secondIndex)
        }else{
            self.delegate?.onCancel()
        }
    }
    
    @objc func textFieldDidChange(){
        self.loadBtn.isEnabled = !startIdTF.text!.isEmpty && !endIdTF.text!.isEmpty
    }
    
    
    func setButtonState(state: ButtonState){
        let prefs = buttonPreferences[state]!
        self.loadBtn.tintColor = prefs.color
        self.loadBtn.setTitle(prefs.text, for: .normal)
    }
    
    private func getButtonState() ->  ButtonState{
        if(self.loadBtn.tintColor == buttonPreferences[.loading]?.color ){
            return .loading
        }
        
        return .canceled
    }
    
}
