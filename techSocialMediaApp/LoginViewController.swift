//
//  ViewController.swift
//  techSocialMediaApp
//
//  Created by Brayden Lemke on 10/20/22.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    var authenticationController = AuthenticationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        emailTextField.text = "JONATHAN.GERBER4791@STU.MTEC.EDU"
        passwordTextField.text = "0e300bb0-2912-4acd-962f-8159e524e80b"
        signInButtonTapped([])
    }

    @IBAction func signInButtonTapped(_ sender: Any) {
        if passwordTextField == nil {
                print("Password text field is nil")
            }
        
        guard let email = emailTextField.text, !email.isEmpty,
                let password = passwordTextField.text, !password.isEmpty else {return}
        
        Task {
            do {
                // Make the API Call
                let success = try await authenticationController.signIn(email: email, password: password)
                if(success) {
                    // Change the navigation stack to make the next view controller be the root view controller
                    // We do this because we dont want a back button to the sign in page.
                    let viewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "userSignedIn")
                    let viewControllers = [viewController]
                    self.navigationController?.setViewControllers(viewControllers, animated: true)
                }
            } catch {
                print(error)
                errorLabel.text = "Invalid Username or Password"
            }
        }
    }
    
}

