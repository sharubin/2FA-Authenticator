//
//  MainScreenView.swift
//  Authenticator 2FA OTP
//
//  Created by Artsem Sharubin on 06.05.2022.
//

import UIKit
import SnapKit
import Then

class MainScreenView: UIView {
    
    let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    
    private let contentView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
        
    private let timePasswordCollectionViewFlowLayout = UICollectionViewFlowLayout().with {
        $0.scrollDirection = .vertical
        $0.minimumInteritemSpacing = 20
    }
    
    lazy var timePasswordCollectionView = UICollectionView(frame: .zero, collectionViewLayout: timePasswordCollectionViewFlowLayout).with {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
        $0.register(TimePasswordCollectionViewCell.self, forCellWithReuseIdentifier: TimePasswordCollectionViewCell.identifier)
    }
    
    private let myTabBar = UITabBar().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
    }
    
    let scanButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "plus.circle.fill")
        $0.setImage(image, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    private func setup() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(timePasswordCollectionView)
        addSubview(myTabBar)
        myTabBar.addSubview(scanButton)
        setNeedsUpdateConstraints()
        backgroundColor = UIColor(red: 241/255, green: 247/255, blue: 242/255, alpha: 1)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        timePasswordCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1000)
        }
        
        myTabBar.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(65)
        }
        
        scanButton.snp.makeConstraints {
            $0.bottom.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
        }
    }
    
}
