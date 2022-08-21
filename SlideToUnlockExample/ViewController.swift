//
//  ViewController.swift
//  SlideToUnlockExample
//
//  Created by 박준현 on 2022/08/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var slideToUnlockView: SlideToUnlockView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slideToUnlockView.delegate = self
    }


}
extension ViewController: SlideToUnlockViewDelegate {
    
    func slideToUnlock(_ slideToUnlockView: SlideToUnlockView) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
            // 사라짐
            self.slideToUnlockView.alpha = 0
        }, completion: nil)
    }
}
