//
//  ATCycleScrollView.swift
//  ATCycleScrollView
//
//  Created by swifter on 2020/4/20.
//

import UIKit
import Kingfisher

public class ATCycleScrollView: UIView {
    
    var totalItemsCount = 0
    
    let identifier = "ATCycleScrollViewCell"
    
    var timer: Timer?
    
    public var imagePathsGroup: [String] = [] {
        didSet {
            totalItemsCount = imagePathsGroup.count * 100
            if imagePathsGroup.count > 1 {
                collectionView.isScrollEnabled = true
                setupTimer()
            } else {
                collectionView.isScrollEnabled = false
                invalidateTimer()
            }
            collectionView.reloadData()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addConstraints()
    }
    
    func scrollToIndex(targetIndex: Int) {
        var targetIndex = targetIndex
        if targetIndex >= totalItemsCount {
            targetIndex = Int(Double(totalItemsCount) * 0.5)
            collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: .left, animated: false)
            return
        }
        collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: .left, animated: true)
    }
    
    @objc func automaticScroll() {
        if totalItemsCount == 0 {
            return
        }
        let targetIndex = currentIndex() + 1
        scrollToIndex(targetIndex: targetIndex)
    }
    
    func currentIndex() -> Int {
        let index = (collectionView.contentOffset.x + layout.itemSize.width * 0.5) / layout.itemSize.width
        return Int(max(0, index))
    }
    
    func setupTimer() {
        timer = Timer(timeInterval: 2, target: self, selector: #selector(automaticScroll), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func pageControlIndexWithCurrentCellIndex(index: NSInteger) -> Int {
        return index % imagePathsGroup.count
    }
    
    func addConstraints() {
        addSubview(collectionView)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layout.itemSize = frame.size
        collectionView.frame = bounds
        if totalItemsCount > 0 {
            let targetIndex = Int(Double(totalItemsCount) * 0.5)
            collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: .left, animated: false)
        }
//        var targetIndex = 0
//        if collectionView.contentOffset.x == 0 && totalItemsCount > 0 {
//            targetIndex = Int(Double(totalItemsCount) * 0.5)
//        }
//        collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: .left, animated: false)
    }
    
    lazy var layout: UICollectionViewFlowLayout = {
        let l = UICollectionViewFlowLayout()
        l.minimumLineSpacing = 0
        l.minimumInteritemSpacing = 0
        l.sectionInset = .zero
        l.scrollDirection = .horizontal
        return l
    }()
    
    lazy var collectionView: UICollectionView = {
        let c = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        c.dataSource = self
        c.delegate = self
        c.register(ATCycleScrollViewCell.self, forCellWithReuseIdentifier: identifier)
        c.isPagingEnabled = true
        c.showsHorizontalScrollIndicator = false
        return c
    }()
}

extension ATCycleScrollView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalItemsCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! ATCycleScrollViewCell
        let itemIndex = pageControlIndexWithCurrentCellIndex(index: indexPath.item)
        let url = imagePathsGroup[itemIndex]
        cell.imageView.kf.setImage(with: URL(string: url))
        print(indexPath.row)
        return cell
    }
}

extension ATCycleScrollView: UICollectionViewDelegateFlowLayout {
    
}

extension ATCycleScrollView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if imagePathsGroup.isEmpty {
//            return
//        }
//        let itemIndex = currentIndex()
//        let index
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        invalidateTimer()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setupTimer()
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidEndScrollingAnimation(collectionView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
}

extension UIColor {
    static var ramdom: UIColor {
        return UIColor(red: CGFloat.random(in: 1...255) / 255.0, green: CGFloat.random(in: 1...255) / 255.0, blue: CGFloat.random(in: 1...255) / 255.0, alpha: 1.0)
    }
}
