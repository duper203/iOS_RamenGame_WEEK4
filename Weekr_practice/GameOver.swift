//
//  GameOver.swift
//  Weekr_practice
//
//  Created by 김혜수 on 2022/11/08.
//

import Foundation
import UIKit
class GameOver: UIViewController{
    
    @IBOutlet weak var totalScore: UILabel!
    @IBOutlet weak var backgorundImg: UIImageView!
    
    @IBOutlet weak var backButton: UIButton!
    var score = 0
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if( score > 8000){
            backgorundImg.image = UIImage(named: "sucess.png")
            totalScore.text = String(score)

            
        }else{
            backgorundImg.image = UIImage(named: "fail.png")
            totalScore.text = String(score)
        }
    }
}
