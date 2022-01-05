//
//  ATCycleScrollView.swift
//  ATCycleScrollView
//
//  Created by swifter on 2020/4/20.
//

import UIKit
import Kingfisher

public class ATCycleScrollView: UIView {
    
    /// block方式监听点击
    var clickItemOperationBlock: ((Int) -> ())?
    
    /// 自动滚动间隔时间,默认2s
    public var autoScrollTimeInterval: TimeInterval = 2 {
        didSet {
            setAutoScroll()
        }
    }
    
    /// 网络图片 url string 数组
    public var imagePathsGroup: [String] = [] {
        didSet {
            invalidateTimer()
            totalItemsCount = imagePathsGroup.count * 100
            pageControl.numberOfPages = imagePathsGroup.count
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
    
    /// 当前分页控件小圆标颜色
    public var currentPageDotColor = UIColor.white {
        didSet {
            pageControl.currentPageIndicatorTintColor = currentPageDotColor
        }
    }
    
    /// 其他分页控件小圆标颜色
    public var pageDotColor = UIColor.lightGray {
        didSet {
            pageControl.pageIndicatorTintColor = pageDotColor
        }
    }
    
    /// 分页控件距离轮播图的底部间距（在默认间距基础上）的偏移量
    public var pageControlBottomOffset: CGFloat = 0
    
    /// 分页控件距离轮播图的右边间距（在默认间距基础上）的偏移量
    public var pageControlRightOffset: CGFloat = 0
    
    private var totalItemsCount = 0

    private let identifier = "ATCycleScrollViewCell"
    private let pageControlDotSize = CGSize(width: 10, height: 10)
    
    private var timer: Timer?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        addConstraints()
    }
    
    func setAutoScroll() {
        invalidateTimer()
        setupTimer()
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
        timer = Timer(timeInterval: autoScrollTimeInterval, target: self, selector: #selector(automaticScroll), userInfo: nil, repeats: true)
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
        addSubview(pageControl)
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
        
        let size = CGSize(width: CGFloat(imagePathsGroup.count) * pageControlDotSize.width * 1.5, height: pageControlDotSize.height)
        let x = (self.width - size.width) * 0.5
        let y = collectionView.height - size.height - 10
        var pageControlFrame = CGRect(x: x, y: y, width: size.width, height: size.height)
        pageControlFrame.origin.y -= pageControlBottomOffset
        pageControlFrame.origin.x -= pageControlRightOffset
        pageControl.frame = pageControlFrame
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview == nil {
            invalidateTimer()
        }
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
        c.backgroundColor = .clear
        return c
    }()
    
    lazy var pageControl: UIPageControl = {
        let p = UIPageControl()
        p.isUserInteractionEnabled = false
        p.currentPageIndicatorTintColor = currentPageDotColor
        p.pageIndicatorTintColor = pageDotColor
        return p
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
        return cell
    }
}

extension ATCycleScrollView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        clickItemOperationBlock?(pageControlIndexWithCurrentCellIndex(index: indexPath.row))
    }
}

extension ATCycleScrollView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if imagePathsGroup.isEmpty {
            return
        }
        let itemIndex = currentIndex()
        let indexOnPageControl = pageControlIndexWithCurrentCellIndex(index: itemIndex)
        pageControl.currentPage = indexOnPageControl
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
