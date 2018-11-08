//
//  ViewController.swift
//  FBLoginSample
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class WelcomeViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (FBSDKAccessToken.current() != nil) {
            print("User Already Logged In")
            //メイン画面へ遷移
            self.performSegue(withIdentifier: "showMain", sender: self)
        } else {
            print("User not Logged In")
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.view.addSubview(loginView)
            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
            loginView.delegate = self
        }
    }
    
    //ログインボタンが押された時の処理。Facebookの認証とその結果を取得する
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        print("User Logged In")
        if ((error) != nil) {
            //エラー処理
        } else if result.isCancelled {
            //キャンセルされた時
        } else {
            //必要な情報が取れていることを確認(今回はemail必須)
            if result.grantedPermissions.contains("email") {
                // 次の画面に遷移
                self.performSegue(withIdentifier: "showMain", sender: self)
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
}

