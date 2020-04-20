//
//  ATCycleScrollViewCell.swift
//  ATCycleScrollView
//
//  Created by swifter on 2020/4/20.
//

import UIKit

class ATCycleScrollViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 300)
    }
    
    func addConstraints() {
        contentView.addSubview(imageView)
    }
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
}
