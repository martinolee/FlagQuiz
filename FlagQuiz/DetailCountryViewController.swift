//
//  DetailCountryViewController.swift
//  FlagQuiz
//
//  Created by 이수한 on 2018. 6. 18..
//  Copyright © 2018년 이수한. All rights reserved.
//

import UIKit
import MapKit

class DetailCountryViewController: UIViewController {
    @IBOutlet weak var detailFlagImageView: UIImageView!
    
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var etcButton: UIButton!
    
    @IBOutlet weak var moverWidth: NSLayoutConstraint!
    @IBOutlet weak var infoButtonCenter: NSLayoutConstraint!
    @IBOutlet weak var mapButtonCenter: NSLayoutConstraint!
    @IBOutlet weak var etcButtonCenter: NSLayoutConstraint!
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var etcView: UIView!
    
    var imageName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectMenu(infoButton)

        detailFlagImageView.image = UIImage(named: imageName!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func selectMenu(_ sender: Any) {
        infoButtonCenter.isActive = (sender as AnyObject).tag == 100
        mapButtonCenter.isActive = (sender as AnyObject).tag == 200
        etcButtonCenter.isActive = (sender as AnyObject).tag == 300
        
        infoButton.setTitleColor(infoButtonCenter.isActive ? UIColor.black : UIColor.lightGray, for: .normal)
        mapButton.setTitleColor(mapButtonCenter.isActive ? UIColor.black : UIColor.lightGray, for: .normal)
        etcButton.setTitleColor(etcButtonCenter.isActive ? UIColor.black : UIColor.lightGray, for: .normal)
        
        if let title = (sender as AnyObject).title(for: .normal), let font = (sender as AnyObject).titleLabel??.font {
            let attr = [NSAttributedStringKey.font: font]
            let width = (title as NSString).size(withAttributes: attr).width
            moverWidth.constant = width + 10
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: { [weak self] in
            self?.view.layoutIfNeeded()
            }, completion: nil)
        
        if sender as? UIButton == infoButton {
            UIView.animate(withDuration: 0.5) {
                self.infoView.alpha = 1
                self.mapView.alpha = 0
                self.etcView.alpha = 0
            }
        } else if sender as? UIButton == mapButton {
            UIView.animate(withDuration: 0.5) {
                self.infoView.alpha = 0
                self.mapView.alpha = 1
                self.etcView.alpha = 0
            }
        } else if sender as? UIButton == etcButton {
            UIView.animate(withDuration: 0.5) {
                self.infoView.alpha = 0
                self.mapView.alpha = 0
                self.etcView.alpha = 1
            }
        }
    }

}
