//
//  MainViewController.swift
//  FBLoginSample
//


import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var currentUserName: UILabel!
    @IBOutlet weak var currentUserEmail: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    var userProfile : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        returnUserData()
    }
    
    @IBAction func logout(_ sender: AnyObject) {
        let loginManager : FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
        self.dismiss(animated: true, completion: nil)
    }
    
    func returnUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(
            graphPath: "me",
            parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]
        )
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil) {
                // エラー処理
                print("Error: \(String(describing: error))")
            } else {
                // プロフィール情報をディクショナリに入れる
                self.userProfile = result as? NSDictionary
                print(self.userProfile)
                
                // プロフィール画像の取得（よくあるように角を丸くする）
                let profileImageURL: String = ((self.userProfile.object(forKey: "picture") as AnyObject)
                    .object(forKey: "data") as AnyObject)
                    .object(forKey: "url") as! String
                
                let profileImage = UIImage(data: NSData(contentsOf: NSURL(string: profileImageURL)! as URL)! as Data)
                self.userImage.clipsToBounds = true
                self.userImage.layer.cornerRadius = 60
//                self.userImage.image = self.trimPicture(rawPic: profileImage!)
                self.userImage.image = profileImage
                
                //名前とemail
                self.currentUserName.text = self.userProfile.object(forKey: "name") as? String
                self.currentUserEmail.text = self.userProfile.object(forKey: "email") as? String
            }
        })
    }
    
    func trimPicture(rawPic:UIImage) -> UIImage {
        let rawImageW = rawPic.size.width
        let rawImageH = rawPic.size.height
        //        let posX = (rawImageW - 200) / 2
        //        let posY = (rawImageH - 200) / 2
        //        let trimArea: CGRect = CGRect(x: posX, y: posY, width: 200, height: 200)
        let rawImageRef: CGImage = rawPic.cgImage! // ??
        let trimmedImageRef = CGImage.cropping(rawImageRef)
        //        var trimmedImageRef = CGImageCreateWithImageInRect(rawImageRef, trimArea)
        let trimmedImage : UIImage = UIImage(cgImage : trimmedImageRef as! CGImage)
        return trimmedImage
    }
}
