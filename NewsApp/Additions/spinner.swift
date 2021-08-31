//
//  spinner.swift
//  NewsApp
//
//  Created by Никита Ломовцев on 30.08.2021.
//

import UIKit

class Spinner: UIImageView{
    
    static let shared = Spinner()
    let width = CGFloat(40)
    let height = CGFloat(40)
    
    func create(centeredFrom view: UIView) {
//        let x = view.frame.size.width / 2 - width / 2
//        let y = view.frame.size.height / 2 - height / 2
//        Spinner.shared.frame = CGRect(x: 0, y: 0, width: width, height: height)
        Spinner.shared.image = UIImage(named: "spinner")
        Spinner.shared.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(Spinner.shared)
        NSLayoutConstraint.activate([Spinner.shared.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     Spinner.shared.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     Spinner.shared.widthAnchor.constraint(equalToConstant: 40),
                                     Spinner.shared.heightAnchor.constraint(equalToConstant: 40)])
        Spinner.shared.isHidden = true
    }
    
    func animation(){
        Spinner.shared.isHidden = false
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.fromValue = 0
        anim.toValue = CGFloat.pi*2
        anim.duration = 0.6
        anim.repeatCount = Float.infinity
        Spinner.shared.layer.add(anim, forKey: "transform.rotation")
    }
    
    func animationRemove(){
        Spinner.shared.layer.removeAllAnimations()
        Spinner.shared.isHidden = true
    }

}


