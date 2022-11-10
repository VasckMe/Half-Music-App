//
//  SortView.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 1.11.22.
//

import UIKit

final class SortView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewInit()
    }
    
    func viewInit() {
        let xibView = Bundle.main.loadNibNamed("SortView", owner: self)![0] as! UIView
        xibView.frame = self.bounds
        addSubview(xibView)
    }
    
    
}
