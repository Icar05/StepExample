//
//  Extension.swift
//  StepExample
//
//  Created by ICoon on 01.02.2022.
//

import Foundation
import UIKit


extension UIView {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
