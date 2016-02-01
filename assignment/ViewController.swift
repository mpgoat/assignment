//
//  ViewController.swift
//  assignment
//
//  Created by miha perne on 01/02/16.
//  Copyright © 2016 miha perne. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {

    var initialConstraint:CGFloat?
    let demoData = ["ena", "dva", "tri", "stiri", "ena", "dva", "tri", "stiri", "ena", "dva", "tri", "stiri", "ena", "dva", "tri", "stiri", "ena", "dva", "tri", "stiri", "ena", "dva", "tri", "stiri", "ena", "dva", "tri", "stiri", "ena", "dva", "tri", "stiri", "ena", "dva", "tri", "stiri"]
    
    @IBOutlet weak var topTableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialConstraint = topTableViewConstraint.constant
        scrollView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        addContent()
    }
    
    func addContent(){
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.height
        
        // add content
        let image1 = UIImageView(frame: CGRectMake(0, 0,scrollViewWidth, scrollViewHeight))
        image1.image = UIImage(named: "1")
        let image2 = UIImageView(frame: CGRectMake(scrollViewWidth, 0,scrollViewWidth, scrollViewHeight))
        image2.image = UIImage(named: "2")
        let image3 = UIImageView(frame: CGRectMake(scrollViewWidth*2, 0,scrollViewWidth, scrollViewHeight))
        image3.image = UIImage(named: "3")
        
        //dodaj subviewe za Summary View
        scrollView.addSubview(image1)
        scrollView.addSubview(image2)
        scrollView.addSubview(image3)
        //
        
        let numberOfSubViews = CGFloat(scrollView.subviews.count)
        pageControl.numberOfPages = scrollView.subviews.count
        
        scrollView.contentSize = CGSizeMake(self.scrollView.frame.width * numberOfSubViews, self.scrollView.frame.height)
        pageControl.currentPage = 0
    }

    // MARK: - ScrollView
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //ce se contentOffset.y manjsa, scrolla gor
        //ko pridemo do 0 zacnemo constraint vecati
        
        tableView.layoutIfNeeded()
        
        if scrollView.isMemberOfClass(UITableView) && topTableViewConstraint.constant > 0 && topTableViewConstraint.constant <= initialConstraint{
            
            if topTableViewConstraint.constant - scrollView.contentOffset.y < 0 {
                topTableViewConstraint.constant = 0
                scrollView.contentOffset.y = 0
            }
            topTableViewConstraint.constant -= scrollView.contentOffset.y

            if topTableViewConstraint.constant < initialConstraint{
                scrollView.contentOffset.y = 0
            }
            
            //skrijemo pageControl, ki sicer seka cez
            if topTableViewConstraint.constant < initialConstraint! - 20{
                UIView.animateWithDuration(0.2) {
                    self.pageControl.alpha = 0
                }
                
            }else if topTableViewConstraint.constant > initialConstraint! - 20{
                UIView.animateWithDuration(0.2) {
                    self.pageControl.alpha = 1
                }
            }
        }

        //naredi da se obdrzi bounce efekt!
        if topTableViewConstraint.constant > initialConstraint{
            topTableViewConstraint.constant = initialConstraint!
        }
        else if topTableViewConstraint.constant < 0{
            topTableViewConstraint.constant = 0
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if scrollView.isMemberOfClass(UITableView) && topTableViewConstraint.constant <= 0 && scrollView.contentOffset.y == 0 {
            print("scroll")
            topTableViewConstraint.constant = 1
            topTableViewConstraint.constant -= scrollView.contentOffset.y
            scrollView.contentOffset.y = 0
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        
        let pageWidth:CGFloat = CGRectGetWidth(scrollView.frame)
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        self.pageControl.currentPage = Int(currentPage);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - DataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demoData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
        cell.textLabel!.text = demoData[indexPath.row]
        cell.selectionStyle = .None
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Super Sticky Header \(section)"
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(red: 0/255, green: 181/255, blue: 229/255, alpha: 1.0)
        header.textLabel!.textColor = UIColor.whiteColor()
        header.alpha = 0.5
    }

}

