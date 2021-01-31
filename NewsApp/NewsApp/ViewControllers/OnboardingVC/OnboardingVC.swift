//
//  OnboardingVC.swift
//  NewsApp
//
//  Created by Satsishur on 12.01.2021.
//

import UIKit

class OnboardingVC: UIViewController {
    //MARK: View items
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("PREV", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(UIColor(red: 52/255, green: 59/255, blue: 70/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        return button
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = pages.count
        pc.currentPageIndicatorTintColor = UIColor(red: 52/255, green: 59/255, blue: 70/255, alpha: 1)
        pc.pageIndicatorTintColor = UIColor(red: 159/255, green: 190/255, blue: 253/255, alpha: 1)
        return pc
    }()
    
    var collectionView: UICollectionView!
    //MARK: Properties
    let pages = [ Page(imageName: "no image", text: "Welcome to ITRA-News!"),
                  Page(imageName: "firstImage", text: "Choose topic for search"),
                  Page(imageName: "secndImage", text: "Browse through topic options"),
                  Page(imageName: "thirdImage", text: "Save articles and comment them")
    ]
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        createControlStack()
        //self.overrideUserInterfaceStyle = .light
    }
    //MARK: Selectors
    @objc private func handleNext() {
        let nextIndex = min(pageControl.currentPage + 1, pages.count - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc private func handlePrev() {
        let nextIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc func handleToContactInfo() {
        UserDefaults.standard.set(true, forKey: "launchedBefore")
        let vc = NewsTabBarVC()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x / view.frame.width)
    }
}
    //MARK: Setup View Layout
extension OnboardingVC {
    func createView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: "cellID")
        layout.scrollDirection = .horizontal
        collectionView.isPagingEnabled = true
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.backgroundColor = .white
    }
    
    func createControlStack() {
        let controlStack = UIStackView(arrangedSubviews: [previousButton, pageControl, nextButton])
        controlStack.translatesAutoresizingMaskIntoConstraints = false
        controlStack.distribution = .fillProportionally
        view.addSubview(controlStack)
        controlStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        controlStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        controlStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        controlStack.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
    //MARK: Collection Deleagte methods
extension OnboardingVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! PageCell
        let page = pages[indexPath.item]
        cell.imageView.image = UIImage(named: page.imageName)
        cell.descriptionTextView.text = page.text
        cell.button.addTarget(self, action: #selector(handleToContactInfo), for: .touchUpInside)
        if indexPath.item == pages.count - 1 {
            cell.button.isHidden = false
            cell.button.isEnabled = true
        } else {
            cell.button.isHidden = true
            cell.button.isEnabled = false
        }
        return cell
    }
}

extension OnboardingVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}
