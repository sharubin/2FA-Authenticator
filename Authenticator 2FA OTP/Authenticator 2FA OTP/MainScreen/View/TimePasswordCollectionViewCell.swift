//
//  TimePasswordCollectionViewCell.swift
//  Authenticator 2FA OTP
//
//  Created by Artsem Sharubin on 06.05.2022.
//

import UIKit
import OneTimePassword

class TimePasswordCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "timePasswordCollectionViewCell"

    let timePasswordLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 25, weight: .bold)
    }
    
    let timerLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .blue
        $0.font = .systemFont(ofSize: 17, weight: .bold)
    }
    
    let loginLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 12, weight: .semibold)
        $0.textColor = .gray
    }
    
    let websiteLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 17, weight: .bold)
    }

    func updateCell(model: Password) {
        let time = Date().timeIntervalSince1970
        var partFrom30Seconds = Double(Int(time/30) + 1) - time/30
        partFrom30Seconds = Double(round(100 * partFrom30Seconds) / 100)
        let secondsBeforeUpdate = Int(partFrom30Seconds * 30)
        guard let url = URL(string: model.oneTimePassword) else { return }
        guard let token = Token(url: url) else { return }
        timePasswordLabel.text = token.currentPassword
        timerLabel.text = "\(secondsBeforeUpdate)"
        loginLabel.text = model.login
        websiteLabel.text = model.website
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
        contentView.addSubview(timePasswordLabel)
        contentView.addSubview(timerLabel)
        contentView.addSubview(loginLabel)
        contentView.addSubview(websiteLabel)
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.cornerRadius = 10
        setNeedsUpdateConstraints()
    }

    override func updateConstraints() {
        super.updateConstraints()

        timePasswordLabel.snp.makeConstraints {
            $0.trailing.top.equalToSuperview().inset(10)
        }
        
        timerLabel.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(10)
        }
        
        websiteLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(10)
        }
        
        loginLabel.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview().inset(10)
        }
    }
}
