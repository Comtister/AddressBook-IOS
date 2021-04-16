//
//  RegisterErrors.swift
//  AddressBook
//
//  Created by Oguzhan Ozturk on 16.04.2021.
//

import Foundation

enum RegisterErrors : Error{
    case emptyFields
    case incorrectPasswords
    case invalidPasswords
    case connectionProblem
    case databaseError
    case userAlreadyExists
}

extension RegisterErrors : LocalizedError{
    
    var errorDescription: String?{
        switch self {
        case .emptyFields:
            return NSLocalizedString("Fill in all fields", comment: "")
        case .incorrectPasswords:
            return NSLocalizedString("Password incorrect", comment: "")
        case .invalidPasswords:
            return NSLocalizedString("Invalid password", comment: "")
        case .connectionProblem:
            return NSLocalizedString("No internet connection", comment: "")
        case .databaseError:
            return NSLocalizedString("an error has occurred", comment: "")
        case .userAlreadyExists:
            return NSLocalizedString("User already Exist", comment: "")
        
        }
    }
    
}
