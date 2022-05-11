//
//  EnumAndStructForDataSource.swift
//  Authenticator 2FA OTP
//
//  Created by Artsem Sharubin on 06.05.2022.
//

import Foundation

enum Section {
    case first
}

struct Password: Hashable {
    let oneTimePassword: String
    let website: String
    let login: String
}
