//
//  OnboardPageCell.swift
//  NewsApp
//
//  Created by Satsishur on 12.01.2021.
//

import UIKit

class PageCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let image = UIImage(named: "firstImage")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Got it!", for: .normal)
        button.backgroundColor = UIColor(red: 52/255, green: 59/255, blue: 70/255, alpha: 1)
        button.layer.cornerRadius = 6
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        let imageContainerView = UIView()
        addSubview(imageContainerView)
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        imageContainerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageContainerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageContainerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        imageContainerView.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor).isActive = true
        //imageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: -12).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageContainerView.heightAnchor, multiplier: 0.5).isActive = true
        addSubview(descriptionTextView)
        descriptionTextView.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 24).isActive = true
        descriptionTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        descriptionTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
        descriptionTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        descriptionTextView.addSubview(button)
        button.centerXAnchor.constraint(equalTo: descriptionTextView.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: descriptionTextView.centerYAnchor).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.widthAnchor.constraint(equalToConstant: 120).isActive = true
    }
}
