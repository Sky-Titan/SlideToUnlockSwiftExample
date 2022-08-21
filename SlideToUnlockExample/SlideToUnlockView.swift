//
//  SlideToUnlockView.swift
//  SlideToUnlockExample
//
//  Created by 박준현 on 2022/08/21.
//

import UIKit

protocol SlideToUnlockViewDelegate: AnyObject {
    func slideToUnlock(_ slideToUnlockView: SlideToUnlockView)
}

class SlideToUnlockView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var leadingMargin: NSLayoutConstraint!
    @IBOutlet weak var textLabel: UILabel!
    weak var delegate: SlideToUnlockViewDelegate?
    
    enum Const {
        static let buttonWidth: CGFloat = 100
        static var unlockOffset: CGFloat {
            UIScreen.main.bounds.width - buttonWidth
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        if Bundle.main.loadNibNamed("SlideToUnlockView", owner: self) != nil {
            addSubview(contentView)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                self.topAnchor.constraint(equalTo: contentView.topAnchor),
                self.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                self.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                self.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
            
            scrollView.contentInsetAdjustmentBehavior = .never
            scrollView.delegate = self
            
            let inset: CGFloat = Const.unlockOffset
            scrollView.contentInset.left = inset // 왼쪽 -> 오른쪽으로 슬라이드 가능하도록 inset 지정
            layoutIfNeeded()
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        }
    }
}
extension SlideToUnlockView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.x
        leadingMargin.constant = -contentOffset
        textLabel.alpha = 1 - (-contentOffset) / (Const.unlockOffset)
        
        if -contentOffset >= Const.unlockOffset {
            // unlock 위치에 도달 시 delegate 호출
            delegate?.slideToUnlock(self)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if -scrollView.contentOffset.x < Const.unlockOffset {
            // 손가락을 떼었을 때, unlock 위치가 아니라면 원래 위치로 되돌아감
            goBack()
        }
    }
    
    private func goBack() {
        DispatchQueue.main.async {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
}
