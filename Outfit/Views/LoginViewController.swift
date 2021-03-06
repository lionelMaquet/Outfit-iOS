//
//  LoginViewController.swift
//  Outfit
//
//  Created by Lionel Maquet on 12/09/2020.
//  Copyright © 2020 Lionel Maquet. All rights reserved.
//


import UIKit
import AuthenticationServices
import Firebase
import CryptoKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginProviderStackView: UIStackView!
    
    let db = Firestore.firestore()
    var currentDBManager : DatabaseManager?
    fileprivate var currentNonce : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProviderLoginView()
    }
    
    private func setupProviderLoginView(){
        let authorizationButton = ASAuthorizationAppleIDButton()
        authorizationButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
        self.loginProviderStackView.addArrangedSubview(authorizationButton)
    }
    
    @objc private func handleAuthorizationAppleIDButtonPress() {
        currentNonce = randomNonceString()
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(currentNonce!)
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    
    
}

extension LoginViewController: ASAuthorizationControllerDelegate {
    

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error!.localizedDescription)
                    return
                }
                // User is signed in to Firebase with Apple.
                // ...
                sharedDatabaseManager = DatabaseManager(userID: idTokenString)
                sharedDatabaseManager!.getCurrentUserInfos()
                self.currentDBManager = DatabaseManager(userID: idTokenString)
                self.currentDBManager!.delegate = self
                
                // way of knowing if user has already initialised his account
                // with a username
                self.currentDBManager?.tryToFetchUsernameOfCurrentUser()
            
            }
            
            
            
            
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }

}

extension LoginViewController: DatabaseManagerDelegate {
    
    
    func isUsernameAlreadyCreated(succeeded: Bool) {
        if succeeded == true {
            self.performSegue(withIdentifier: "goToTabBarController", sender: self)
        } else {
            self.performSegue(withIdentifier: "goToPickUsernameVC", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "goToPickUsernameVC" {
            let destinationVC = segue.destination as! PickUsernameViewController
            destinationVC.dbManager = self.currentDBManager
        }
        
        else if segue.identifier == "goToTabBarController" {
            let destinationVC = segue.destination as! UITabBarController
            let homeVC = destinationVC.viewControllers![0].children[0] as! HomeViewController
            homeVC.dbManager = self.currentDBManager
        }
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}




