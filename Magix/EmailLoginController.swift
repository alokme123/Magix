//
//  EmailLoginController.swift
//  Magix
//
//  Created by Alok N on 16/04/21.
//

import UIKit
import Firebase

class EmailLoginController: UIViewController {

    //OUTLETS
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButtonOB: UIButton!
    
    
    
    //FIREBASE FUNCTIONS
    var firebaseAuth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 20
        registerButtonOB.layer.cornerRadius = 20
        
        firstNameField.isHidden = true
        lastNameField.isHidden = true
        setBorders(fieldName: emailField, borderColor: UIColor.lightGray.cgColor,animate: false)
        setBorders(fieldName: passField, borderColor: UIColor.lightGray.cgColor,animate: false)
        setBorders(fieldName: firstNameField, borderColor: UIColor.lightGray.cgColor,animate: false)
        setBorders(fieldName: lastNameField, borderColor: UIColor.lightGray.cgColor,animate: false)
    }
    
    override func updateViewConstraints() {
        self.view.frame.size.height = UIScreen.main.bounds.height - 300
        self.view.frame.origin.y =  300
        self.view.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
        super.updateViewConstraints()
    }
    
    func setBorders(fieldName:UITextField, borderColor:CGColor, animate:Bool) -> () {
        //fieldName.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        fieldName.layer.borderWidth = 2
        fieldName.layer.cornerRadius = 10
        fieldName.clipsToBounds = true
        if(animate){
            UIView.transition(with: fieldName, duration: 0.5, options: .transitionCrossDissolve, animations: { fieldName.layer.borderColor = borderColor })
        }
    }
    
    @IBAction func loginButton(_ sender: Any) {
        var flag = true
        if(emailField.text!.isEmpty){
            setBorders(fieldName: emailField, borderColor: UIColor.red.cgColor, animate: true)
            flag = false
        } else {setBorders(fieldName: emailField, borderColor: UIColor.lightGray.cgColor, animate: true)}
        if(passField.text!.isEmpty){
            setBorders(fieldName: passField, borderColor: UIColor.red.cgColor, animate: true)
            flag = false
        } else {setBorders(fieldName: passField, borderColor: UIColor.lightGray.cgColor, animate: true)}
        if(flag){
            firebaseAuth.signIn(withEmail: emailField.text!, password: passField.text!, completion: {(authResult, error) in
                if let error = error as NSError?{
                    print(error)
                    if let code = AuthErrorCode(rawValue: error.code) {
                        switch code.rawValue {
                        case 17009:
                            self.alertPrompt(message: "Invalid username or password", title: "Oops!", prompt: "OK")
                            break
                        case 17011:
                            self.alertPrompt(message: "Invalid username or password", title: "Oops!", prompt: "OK")
                            break
                        default:
                            self.alertPrompt(message: "Unknown Error", title: "Oops!", prompt: "OK")
                        }
                    }
                    else{
                        self.alertPrompt(message: "Unknown Error", title: "Oops!", prompt: "OK")
                    }
                    return
                }
                print("Success Logged In: \(authResult!.user.email!)")
                self.dismiss(animated: true)
            })
        }
    }
    
    @IBAction func registerButton(_ sender: Any) {
        if(self.firstNameField.isHidden){
            UIView.transition(with: firstNameField, duration: 0.5, options: .transitionCrossDissolve, animations: { self.firstNameField.isHidden = false })
            UIView.transition(with: lastNameField, duration: 0.5, options: .transitionCrossDissolve, animations: { self.lastNameField.isHidden = false })
            return
        }
        var flag = true
        
        if(emailField.text!.isEmpty){
            setBorders(fieldName: emailField, borderColor: UIColor.red.cgColor, animate: true)
            flag = false
        } else {
            setBorders(fieldName: emailField, borderColor: UIColor.lightGray.cgColor, animate: true)
        }
        if(passField.text!.isEmpty){
            setBorders(fieldName: passField, borderColor: UIColor.red.cgColor, animate: true)
            flag = false
        } else {
            setBorders(fieldName: passField, borderColor: UIColor.lightGray.cgColor, animate: true)
        }
        if(firstNameField.text!.isEmpty){
            setBorders(fieldName: firstNameField, borderColor: UIColor.red.cgColor, animate: true)
            flag = false
        } else {
            setBorders(fieldName: firstNameField, borderColor: UIColor.lightGray.cgColor, animate: true)
        }
        if(lastNameField.text!.isEmpty){
            setBorders(fieldName: lastNameField, borderColor: UIColor.red.cgColor, animate: true)
            flag = false
        } else {
            setBorders(fieldName: lastNameField, borderColor: UIColor.lightGray.cgColor, animate: true)
        }
        if(flag){
            firebaseAuth.createUser(withEmail: emailField.text!, password: passField.text!, completion: {authResult,error in print("Done!")})
        }
    }
    
    func alertPrompt(message: String, title: String, prompt: String) -> () {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: prompt, style: UIAlertAction.Style.default))
        self.present(alert, animated: true)
    }
    
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
 }
