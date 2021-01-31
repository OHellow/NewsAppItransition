//
//  ArticleTableViewCell.swift
//  NewsApp
//
//  Created by Satsishur on 18.01.2021.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {

    // MARK: - View items
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var saveNewsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "bookmark.circle"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    var commentsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "bubble.left"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.isHidden = true
        return button
    }()
    //MARK: Properties
    private lazy var imageViewHeight: NSLayoutConstraint = newsImageView.heightAnchor.constraint(equalToConstant: 0)
    var buttonAction: (() -> Void)?
    var buttonCommentAction: (() -> Void)?
    
    //MARK: Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        saveNewsButton.addTarget(self, action: #selector(pressRightBUtton), for: .touchUpInside)
        commentsButton.addTarget(self, action: #selector(pressDeleteButton), for: .touchUpInside)
     }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func setupView() {
        setSubviews()
        setupConstraints()
    }
    
    func setSubviews() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(newsImageView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(saveNewsButton)
        contentView.addSubview(commentsButton)
    }
    
    func setupConstraints() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        dateLabel.setContentHuggingPriority(.init(rawValue: 100), for: .vertical)
        dateLabel.setContentCompressionResistancePriority(.init(rawValue: 100), for: .vertical)
        
        saveNewsButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        saveNewsButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        saveNewsButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        saveNewsButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        commentsButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        commentsButton.rightAnchor.constraint(equalTo: saveNewsButton.leftAnchor, constant: -8).isActive = true
        commentsButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        commentsButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 4).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        titleLabel.setContentHuggingPriority(.init(rawValue: 75), for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.init(rawValue: 75), for: .vertical)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 4).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4).isActive = true
        descriptionLabel.setContentHuggingPriority(.init(rawValue: 50), for: .vertical)
        descriptionLabel.setContentCompressionResistancePriority(.init(rawValue: 50), for: .vertical)
        
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        newsImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4).isActive = true
        newsImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        newsImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        imageViewHeight.isActive = true
    }
    // MARK: - Model injection
    func configure(model: Article) {
        dateLabel.text = Date.ptBRFormatter.string(from: model.publishedAt ?? Date())
        titleLabel.text = model.title ?? "no info"
        descriptionLabel.text = model.description
        if let url = model.urlToImage {
            self.imageViewHeight.constant = 150
            newsImageView.downloadImage(from: url)
        }
    }
    
    func configureFromCD(model: News) {
        if let date = model.publishedAt {
            dateLabel.text = Date.ptBRFormatter.string(from: date)
        }
        titleLabel.text = model.title
        descriptionLabel.text = model.descriptionArticle
        if let url = model.urlToImage {
                    self.imageViewHeight.constant = 150
            newsImageView.downloadImage(from: url)
        }
    }

    @objc func pressRightBUtton() {
        self.buttonAction?()
    }
    
    @objc func pressDeleteButton() {
        self.buttonCommentAction?()
    }
}
