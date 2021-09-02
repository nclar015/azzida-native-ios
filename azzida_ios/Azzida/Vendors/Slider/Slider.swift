//
//  Slider.swift
//  Slider-swift
//
//  Created by Varun Naharia on 20/03/17.
//  Copyright © 2017 Varun Naharia. All rights reserved.
//

import UIKit
import Kingfisher
class Slider: UIView, UIScrollViewDelegate {

    var customView: UIView?
    @IBOutlet weak var slider: UIScrollView!
    @IBOutlet weak var pagger: UIPageControl!
    var slides:[String] = []
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            self.initialize()
        }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
        override func awakeFromNib() {
            super.awakeFromNib()
            self.initialize()
        }
        
        override func prepareForInterfaceBuilder() {
            self.initialize()
        }
    
    func initialize() {
        // 1. Load the .xib file .xib file must match classname
        let className: String = "Slider"
        customView = Bundle.main.loadNibNamed("Slider", owner: self, options: nil)?[0] as? UIView
        customView?.frame = self.bounds
        // 2. Set the bounds if not set by programmer (i.e. init called)
        //    if(CGRectIsEmpty(frame)) {
        //        self.bounds = _customView.bounds;
        //    }
        // 3. Add as a subview
        self.addSubview(customView!)
        //    pagger.hidden = YES;
        /*slides = [[NSMutableArray alloc] init];
         [slides addObject:@"http://www.planwallpaper.com/static/images/Nature-Background-Wallpapers-8_gxwmqmj.jpg"];
         [slides addObject:@"http://wallpapercave.com/wp/eas6Et3.jpg"];
         [slides addObject:@"https://images.freecreatives.com/wp-content/uploads/2015/06/beautiful-nature-background.jpg"];
         [slides addObject:@"http://hdwallpaperbackgrounds.net/wp-content/uploads/2016/07/Nature-background-12.jpg"];
         [self setupSliderView];*/
        pagger.currentPage = 1
        //    pagger.currentPageIndicatorTintColor = [UIColor redColor];
        //    pagger.pageIndicatorTintColor = [UIColor colorWithRed:0.137 green:0.651 blue:0.510 alpha:1.00];
    }
    
    func setupSliderView() {
        //    pagger.alpha = 0;
        slider.isPagingEnabled = true
        slider.delegate = self
        pagger.numberOfPages = slides.count
        //pagger.backgroundColor = [UIColor blueColor];
        for view: UIView in slider.subviews {
            if (view is UIImageView) {
                view.removeFromSuperview()
            }
        }
        var i: Int = 0
        for str: String in slides {
            let imageView = UIImageView()
            //imageView.backgroundColor = [UIColor blueColor];
            imageView.kf.setImage(with: URL(string: str))
            imageView.contentMode = .scaleAspectFill
            //sd_setImage(with: URL(string: str), placeholderImage: UIImage(named: "Property"))
            imageView.frame = CGRect(x: CGFloat(slider.frame.size.width * CGFloat(i)), y: CGFloat(0), width: CGFloat(slider.frame.size.width), height: CGFloat(slider.frame.size.height))
            //imageView.backgroundColor = [[UIColor alloc] initWithRed:arc4random()%256/256.0 green:arc4random()%256/256.0 blue:arc4random()%256/256.0 alpha:1.0];
            slider.addSubview(imageView)
            i += 1
        }
        slider.contentSize = CGSize(width: CGFloat(slider.frame.size.width * CGFloat(slides.count)), height: CGFloat(slider.frame.size.height))
        //    [self addSubview:slider];
        Timer.scheduledTimer(timeInterval: 7, target: self, selector: #selector(self.autoStartSlide), userInfo: nil, repeats: true)
        self.setNeedsLayout()
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        slider.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.frame.size.width), height: CGFloat(self.frame.size.height))
        var i: Int = 0
        for view: UIView in slider.subviews {
            if (view is UIImageView) {
                view.frame = CGRect(x: CGFloat(slider.frame.size.width * CGFloat(i)), y: CGFloat(0), width: CGFloat(slider.frame.size.width), height: CGFloat(slider.frame.size.height))
                i += 1
            }
        }
        slider.contentSize = CGSize(width: CGFloat(slider.frame.size.width * CGFloat(slides.count)), height: CGFloat(slider.frame.size.height))
        //    pagger.frame = CGRectMake(self.frame.size.width-((self.frame.size.width*0.25)+15), self.frame.size.height-40, self.frame.size.width*0.25, 30);
        self.bringSubviewToFront(pagger)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = slider.contentOffset.x / CGFloat(slider.frame.size.width)
        pagger.currentPage = Int(page)
    }
    
    @objc func autoStartSlide(_ sender: Any) {
        if(self.slides.count > 1)
        {
            if pagger.numberOfPages > pagger.currentPage + 1 {
                UIView.animate(withDuration: 0.5, animations: {() -> Void in
                    self.slider.contentOffset = CGPoint(x: CGFloat(self.slider.contentOffset.x + self.slider.frame.size.width), y: CGFloat(0))
                }, completion: {(_ finished: Bool) -> Void in
                    //sliderScrollView.contentOffset = CGPointMake(sliderScrollView.contentOffset.x + sliderScrollView.frame.size.width, 0);
                })
            }
            else {
                slider.contentOffset = CGPoint(x: CGFloat(slider.contentOffset.x - slider.frame.size.width), y: CGFloat(0))
                UIView.animate(withDuration: 0.5, animations: {() -> Void in
                    self.slider.contentOffset = CGPoint(x: CGFloat(self.slider.contentOffset.x + self.slider.frame.size.width), y: CGFloat(0))
                }, completion: {(_ finished: Bool) -> Void in
                    self.slider.contentOffset = CGPoint(x: CGFloat(0), y: CGFloat(0))
                })
            }
        }
    }

}
