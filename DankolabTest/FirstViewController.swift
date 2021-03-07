//
//  ViewController.swift
//  DankolabTest
//
//  Created by Mikhail Danilov on 01/03/2021.
//  Copyright © 2021 Om. All rights reserved.
//

import UIKit
import SwiftHEXColors

class ViewController: UIViewController {
    
    let colorWhite: UIColor? = UIColor(hex: 0xFFFFFF)
    let colorBlack: UIColor? = UIColor(hex: 0x000000)
    let colorBtn: UIColor? = UIColor(hex: 0xCF1F28)
    let colorBntShadow: UIColor? = UIColor(hex: 0xE4222D)
    let colorBntColorText: UIColor? = UIColor(hex: 0xFFFFFF)
    
    @IBOutlet var superView: UIView!
    
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var btnOutlet: UIButton!
    
    @IBOutlet weak var viewLoad: UIView!
    
    @IBOutlet weak var indicatorImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        superView.layer.backgroundColor = colorWhite?.cgColor
        
        imgLogo.layer.shadowColor = colorBlack?.cgColor
        imgLogo.layer.shadowOpacity = 0.5
        imgLogo.layer.shadowOffset = CGSize(width: 0, height: 2)
        imgLogo.layer.shadowRadius = 4
        
        btnOutlet.layer.backgroundColor = colorBtn?.cgColor
        btnOutlet.layer.shadowRadius = 9
        btnOutlet.setTitleColor(colorBntColorText, for: .normal)
        btnOutlet.layer.shadowColor = colorBntShadow?.cgColor
        btnOutlet.layer.shadowOpacity = 0.5
        btnOutlet.layer.shadowOffset = CGSize(width: 0, height: 2)
        btnOutlet.layer.cornerRadius = btnOutlet.bounds.size.height / 2
        btnOutlet.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btnOutlet.alpha = 0
        
        indicatorImage.image = UIImage(named: "activityIndicator")
        indicatorImage.isHidden = true
        
        UIView.animate(withDuration: 2) {
            self.btnOutlet.frame.origin.x = -300
            self.btnOutlet.alpha = 1
        }
    }
    
    @IBAction func btnAction(_ sender: Any) {
        self.viewLoad.isHidden = false
        self.viewLoad.alpha = 0.0
        self.indicatorImage.alpha = 0.0
        self.indicatorImage.isHidden = false
        rotateImageView()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.indicatorImage.alpha = 1
            self.viewLoad.alpha = 0.4
        }, completion: { _ in
            self.hideViewLoad()
        })
    }
    private func hideViewLoad() {
        UIView.animate(withDuration: 0.1, delay: 0.4, options: [], animations: {
            self.viewLoad.alpha = 0.0
        }, completion: { _ in
            self.showChats()
        })
    }
    
    private func showChats() {
        self.performSegue(withIdentifier: "segueChats", sender: self)
    }
    
    private func rotateImageView() {
        UIView.animate(withDuration: 0.2, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: { () -> Void in
            self.indicatorImage.transform = self.indicatorImage.transform.rotated(by: CGFloat(Double.pi / 2))
        }) { (finished) -> Void in
            if finished {
                self.rotateImageView()
            }
        }
    }
}
