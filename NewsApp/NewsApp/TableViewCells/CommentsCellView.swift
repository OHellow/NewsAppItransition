//
//  CommentsCellView.swift
//  NewsApp
//
//  Created by Satsishur on 30.01.2021.
//

import UIKit

class CommentsCellView: UITableViewCell {
    let textView: UITextView = {
         let textView = UITextView()
         textView.translatesAutoresizingMaskIntoConstraints = false
         textView.text = "New Comment"
         textView.textAlignment = .left
         textView.backgroundColor = .white
         textView.isEditable = true
         return textView
     }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        button.widthAnchor.constraint(equalToConstant: 20).isActive = true
        button.setImage(UIImage(systemName: "trash.circle"), for: .normal)
        return button
    }()
    
    var buttonAction: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        deleteButton.addTarget(self, action: #selector(pressDeleteButton), for: .touchUpInside)
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        textView.layer.cornerRadius = 5
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.clipsToBounds = false
//        textView.layer.shadowOpacity = 0.4
//        textView.layer.shadowOffset = CGSize(width: 1, height: 1)
    }
        
    func setupView() {
        setSubviews()
        setupConstraints()
    }
    
    func setSubviews() {
        contentView.addSubview(textView)
        contentView.addSubview(deleteButton)
    }
    
    func setupConstraints() {
        deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        deleteButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        textView.topAnchor.constraint(equalTo: deleteButton.bottomAnchor, constant: 4).isActive = true
        textView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        textView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
    }
    
    func configure(model: Comment) {
        textView.text = model.text ?? "New comment"
    }

    @objc func pressDeleteButton() {
        self.buttonAction?()
        print(222)
    }
}
