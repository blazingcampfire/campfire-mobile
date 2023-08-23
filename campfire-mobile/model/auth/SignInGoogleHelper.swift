//
//  SignInGoogleHelper.swift
//  campfire-mobile
//
//  Created by Toni on 7/15/23.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
    let result: GIDSignInResult
}

final class SignInGoogleHelper {
    @MainActor
    func signIn() async throws -> GoogleSignInResultModel {
        guard let topVC = Utilities.shared.topViewController()
        else {
            throw URLError(.cannotFindHost)
        }

        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)

        guard let idToken: String = gidSignInResult.user.idToken?.tokenString
        else {
            throw URLError(.badServerResponse)
        }
        let accessToken = gidSignInResult.user.accessToken.tokenString

        let tokens = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken, result: gidSignInResult)
        return tokens
    }
}
