//
//  FullScreenSlideshowViewController.swift
//  ImageSlideshow
//
//  Created by Petr Zvoníček on 31.08.15.
//

import UIKit

open class FullScreenSlideshowViewController: UIViewController {
    
    
    
    open var slideshow: ImageSlideshow = {
        var slideshow = ImageSlideshow()
        let Red_Carlo:UIColor = UIColor(red: 166/255, green: 29/255, blue: 40/255, alpha: 1)
        slideshow.fullScreen = true
        slideshow.zoomEnabled = true
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFit
        slideshow.pageControlPosition = PageControlPosition.insideScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = Red_Carlo
        slideshow.pageControl.pageIndicatorTintColor = UIColor.white
        slideshow.pageControl.isUserInteractionEnabled = false
        // turns off the timer
        slideshow.slideshowInterval = 0
        slideshow.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        
        
        return slideshow
    }()
    
    open var closeButton = UIButton()
    open var pageSelected: ((_ page: Int) -> ())?
    open var images: ((_ images: [InputSource]) -> ())?
    
    /// Index of initial image
    open var initialImageIndex: Int = 0
    open var inputs: [InputSource]?
    
    /// Background color
    open var backgroundColor = UIColor.black
    
    /// Enables/disable zoom
    open var zoomEnabled = true {
        didSet {
            slideshow.zoomEnabled = zoomEnabled
        }
    }
    
    fileprivate var isInit = true
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = backgroundColor
        
        // slideshow view configuration
        slideshow.frame = view.frame
        slideshow.backgroundColor = backgroundColor
        
        if var inputs = inputs {
            slideshow.setImageInputs(inputs)
            slideshow.pageControl.numberOfPages = inputs.count
            //slideshow.Allhouses = true
        }
        
        slideshow.frame = view.frame
        view.addSubview(slideshow);
        
        // close button configuration
        closeButton.frame = CGRect(x: UIScreen.main.bounds.width - 50, y: 10, width: 30, height: 30)
        closeButton.setImage(UIImage(named: "Frameworks/ImageSlideshow.framework/ImageSlideshow.bundle/ic_cross_white@2x"), for: UIControlState())
        closeButton.addTarget(self, action: #selector(FullScreenSlideshowViewController.close), for: UIControlEvents.touchUpInside)
        view.addSubview(closeButton)
    }
    
    open override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        closeButton.frame = CGRect(x: UIScreen.main.bounds.width - 50, y: 10, width: 30, height: 30)
    }
    
    override open var prefersStatusBarHidden : Bool {
        return true
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isInit {
            isInit = false
            slideshow.setScrollViewPage(initialImageIndex, animated: false)
        }
    }
    
    func close() {
        
        if let pageSelected = pageSelected {
            pageSelected(slideshow.scrollViewPage)
        }
        slideshow.fullScreen = false
        
        slideshow.setImageInputs(slideshow.images)
        slideshow.setScrollViewPage(slideshow.scrollViewPage, animated: false)
        self.zoomEnabled = false
        tabBarController?.selectedIndex = 1
        self.dismiss(animated: true, completion: nil)
        //let _ = self.navigationController?.popViewController(animated: true)
    }
}
