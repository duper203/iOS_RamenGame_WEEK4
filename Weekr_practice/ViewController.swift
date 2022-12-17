//
//  ViewController.swift
//  Weekr_practice
//
//  Created by 김혜수 on 2022/11/06.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
  
    //완성 라면 점수
    var score = 0;
    @IBOutlet weak var scoreText: UILabel!
    
    //ingredient button
    @IBOutlet weak var WaterBtn: UIButton!
    @IBOutlet weak var SoupBtn: UIButton!
    @IBOutlet weak var NoodleBtn: UIButton!
    @IBOutlet weak var GreenBtn: UIButton!
    @IBOutlet weak var EggBtn: UIButton!
    
    
    //라면 이미지 배열
    let ramenImage = [UIImage(named: "ramen1"), UIImage(named: "ramen2"), UIImage(named: "ramen3"), UIImage(named: "ramen4"), UIImage(named: "ramen5"), UIImage(named: "ramen6"), UIImage(named: "ramen7")]
    
    //라면 상태
    var ramenStatus = ["0","0", "0", "0"]
    var timerCounting:[Bool] = [false,false,false,false]
    
    var mainCountStatus:Bool = false


    //선택한 재료 설정
    var ingredientHolding: String = ""
    
    @IBAction func WaterBtn(_ sender: Any) {
        ingredientHolding = "water"
        print("ingredientHolding = water")
    }
    @IBAction func SoupBtn(_ sender: Any) {
        ingredientHolding = "soup"
        print("ingredientHolding = soup")
    }
    @IBAction func NoodleBtn(_ sender: Any) {
        ingredientHolding = "noodle"
        print("ingredientHolding = noodle")
    }
    @IBAction func GreenBtn(_ sender: Any) {
        ingredientHolding = "green"
        print("ingredientHolding = green")
    }
    @IBAction func EggBtn(_ sender: Any) {
        ingredientHolding = "egg"
        print("ingredientHolding = egg")
    }
    
    //pot button
    @IBOutlet weak var PotOne: UIButton!
    @IBOutlet weak var PotTwo: UIButton!
    @IBOutlet weak var PotThree: UIButton!
    @IBOutlet weak var PotFour: UIButton!
    
    //오디오 플레이어 선언
    var soundEffect = AVAudioPlayer()
    
    //배경음악
    func music(){
        print("music Start")
        
        let url = Bundle.main.url(forResource: "BGM", withExtension: "mp3")
        
        if let url = url{
            do {
                soundEffect = try AVAudioPlayer(contentsOf: url)
                soundEffect.prepareToPlay()
                soundEffect.play()
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        music()

    }
    
    override func viewDidAppear(_ animated: Bool) {
           mainLoop()
       }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        //모든 것을 초기화
        
        
        ramenStatus = ["0","0", "0", "0"]
        mainCount = 0
        score = 0
        scoreText.text = "\(score)"


        ingredientHolding = ""
        PotOne.setImage(ramenImage[0], for: .normal)
        PotTwo.setImage(ramenImage[0], for: .normal)
        PotThree.setImage(ramenImage[0], for: .normal)
        PotFour.setImage(ramenImage[0], for: .normal)

        timer1.invalidate()
        PotOneTime = 0

        timer2.invalidate()
        PotTwoTime = 0

        timer3.invalidate()
        PotThreeTime = 0

        timer4.invalidate()
        PotFourTime = 0

    }
    
    //화면 가로로 설정
    override var shouldAutorotate: Bool{
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .landscapeRight
    }
        
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .landscapeRight
    }
    
 
    
//MARK - 메인 타이머 progessview와 함께 구현
    @IBOutlet weak var timeProgress: UIProgressView!
    var mainCount: Int = 0
    var timer = Timer()
    @objc func mainTimerCounter() -> Void
        {
            mainCount = mainCount + 1
            
            if(mainCount<=60){
                print("총 남은 게임 시간 : " + String(60-mainCount) + "초")
                timeProgress.setProgress(timeProgress.progress - 0.0167, animated: true)
            }
            else{
                timer.invalidate()
                print("게임 종료")
                mainCountStatus = false
                timerCounting = [false,false,false,false]
                print("총 수입금:",score)

                

                // 다음 컨트롤러에 대한 인스턴스 생성
                guard let vc = storyboard?.instantiateViewController(withIdentifier: "GameOver") as? GameOver else { return }
                
                vc.score = score

                vc.modalPresentationStyle = .fullScreen
                // 화면을 전환하다.
                present(vc, animated: true)
            }
    }

    //메인 루프
    func mainLoop(){
        mainCountStatus = true
        let runLoop = RunLoop.current
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(mainTimerCounter), userInfo: nil, repeats: true)
        
        while mainCountStatus{
            runLoop.run(until: Date().addingTimeInterval(0.1))
        }
    }
    
//MARK - 라면 냄비 1
    
    //라면 냄비 1 타이머 - 스레드
    var timer1 = Timer()
    var PotOneTime = 0
    
    @objc func PotOneCount(){
        PotOneTime = PotOneTime + 1
        if(PotOneTime < 15){
            print("1번 냄비 남은 게임 시간 : " + String(15-PotOneTime) + "초")
        }
        else{
            timer1.invalidate()
            print("1번 냄비 탐")
            timerCounting[0]  = false
            ramenStatus[0] = "burnt"
            PotOneTime = 0

            
            DispatchQueue.main.sync {
                PotOne.setImage(ramenImage[6], for: .normal)
            }
            
        }
    }
    //라면 냄비 1 재료 넣기
    @IBAction func PotOne(_ sender: Any) {
        if (ingredientHolding == "water" && ramenStatus[0] == "0"){
            print("water -> 냄비1")
            ramenStatus[0] = "water"
            print(ramenStatus[0])
            PotOne.setImage(ramenImage[1], for: .normal)
            
            //타이머 시작
            DispatchQueue.global(qos: .userInitiated).async { [self] in
                timerCounting[0] = true
                let runLoop = RunLoop.current
                timer1 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PotOneCount), userInfo: nil, repeats: true)
                
                while timerCounting[0]{
                    runLoop.run(until: Date().addingTimeInterval(0.1))
                }
            }
        }
        else if (ingredientHolding == "soup" && ramenStatus[0] == "water"){
            print("soup -> 냄비1")
            ramenStatus[0] = "soup"
            print(ramenStatus[0])
            PotOne.setImage(ramenImage[2], for: .normal)
        }
        else if(ingredientHolding == "noodle" && ramenStatus[0] == "soup"){
            print("noodle -> 냄비1")
            ramenStatus[0] = "noodle"
            PotOne.setImage(ramenImage[3], for: .normal)
        }
        else if(ingredientHolding == "green" && ramenStatus[0] == "noodle"){
            print("green -> 냄비1")
            ramenStatus[0] = "green"
            PotOne.setImage(ramenImage[4], for: .normal)
        }
        else if(ingredientHolding == "egg" && ramenStatus[0] == "green"){
            print("egg -> 냄비1")
            ramenStatus[0] = "egg"
            PotOne.setImage(ramenImage[5], for: .normal)
        }else if(ramenStatus[0] == "egg"){
            print("라면1 완료")
            //점수 올리기
            score += 1000
            scoreText.text = "\(score)"
            
            //라면 냄비 rest시키기
            timer1.invalidate()
            timerCounting[0]  = false
            ramenStatus[0] = "0"
            PotOne.setImage(ramenImage[0], for: .normal)
            PotOneTime = 0

            
        }else if(ramenStatus[0] == "burnt"){
            ramenStatus[0] = "0"
            PotOne.setImage(ramenImage[0], for: .normal)
            
        }else{
            print("순서가 잘못되었습니다")
        }
    }
    
//MARK - 라면 냄비 2
    //타이머 2
    var timer2 = Timer()
    var PotTwoTime = 0
    
    @objc func PotTwoCount(){
        PotTwoTime = PotTwoTime + 1
        if(PotTwoTime < 15){
            print("2번 냄비 남은 게임 시간 : " + String(15-PotTwoTime) + "초")
        }
        else{
            timer2.invalidate()
            print("2번 냄비 탐")
            timerCounting[1]  = false
            ramenStatus[1] = "burnt"
            PotTwoTime = 0
            DispatchQueue.main.sync {
                PotTwo.setImage(ramenImage[6], for: .normal)
            }
            
        }
    }
    //라면 재료 넣기
    @IBAction func PotTwo(_ sender: Any) {
        if (ingredientHolding == "water" && ramenStatus[1] == "0"){
            print("water -> 냄비2")
            ramenStatus[1] = "water"
            print(ramenStatus[1])
            PotTwo.setImage(ramenImage[1], for: .normal)
            
            //타이머 시작
            DispatchQueue.global(qos: .userInitiated).async { [self] in
                timerCounting[1] = true
                let runLoop = RunLoop.current
                timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PotTwoCount), userInfo: nil, repeats: true)
                
                while timerCounting[1]{
                    runLoop.run(until: Date().addingTimeInterval(0.1))
                }
            }
        }
        else if (ingredientHolding == "soup" && ramenStatus[1] == "water"){
            print("soup -> 냄비2")
            ramenStatus[1] = "soup"
            print(ramenStatus[1])
            PotTwo.setImage(ramenImage[2], for: .normal)
        }
        else if(ingredientHolding == "noodle" && ramenStatus[1] == "soup"){
            print("noodle -> 냄비2")
            ramenStatus[1] = "noodle"
            PotTwo.setImage(ramenImage[3], for: .normal)
        }
        else if(ingredientHolding == "green" && ramenStatus[1] == "noodle"){
            print("green -> 냄비2")
            ramenStatus[1] = "green"
            PotTwo.setImage(ramenImage[4], for: .normal)
        }
        else if(ingredientHolding == "egg" && ramenStatus[1] == "green"){
            print("egg -> 냄비2")
            ramenStatus[1] = "egg"
            PotTwo.setImage(ramenImage[5], for: .normal)
        }
        else if(ramenStatus[1] == "egg"){
            //점수 올리기
            score += 1000
            scoreText.text = "\(score)"
            
            //라면 냄비 reset시키기
            ramenStatus[1] = "0"
            PotTwo.setImage(ramenImage[0], for: .normal)
            
            //라면 냄비 rest시키기
            timer2.invalidate()
            timerCounting[1]  = false
            PotTwoTime = 0

            
        }else if(ramenStatus[1] == "burnt"){
            ramenStatus[1] = "0"
            PotTwo.setImage(ramenImage[0], for: .normal)
        }else{
            print("순서가 잘못되었습니다")
        }
    }
    
    
//MARK - 라면 냄비 3
    var timer3 = Timer()
    var PotThreeTime = 0
    
    @objc func PotThreeCount(){
        PotThreeTime = PotThreeTime + 1
        if(PotThreeTime < 15){
            print("3번 냄비 남은 게임 시간 : " + String(15-PotThreeTime) + "초")
        }
        else{
            timer3.invalidate()
            print("3번 냄비 탐")
            timerCounting[2]  = false
            ramenStatus[2] = "burnt"
            PotThreeTime = 0
            DispatchQueue.main.sync {
                PotThree.setImage(ramenImage[6], for: .normal)
            }
            
        }
    }
    
    @IBAction func PotThree(_ sender: Any){
        if (ingredientHolding == "water" && ramenStatus[2] == "0"){
            print("water -> 냄비3")
            ramenStatus[2] = "water"
            print(ramenStatus[1])
            PotThree.setImage(ramenImage[1], for: .normal)
            
            //타이머 시작
            DispatchQueue.global(qos: .userInitiated).async { [self] in
                timerCounting[2] = true
                let runLoop = RunLoop.current
                timer3 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PotThreeCount), userInfo: nil, repeats: true)
                
                while timerCounting[2]{
                    runLoop.run(until: Date().addingTimeInterval(0.1))
                }
            }
        }
        else if (ingredientHolding == "soup" && ramenStatus[2] == "water"){
            print("soup -> 냄비3")
            ramenStatus[2] = "soup"
            print(ramenStatus[1])
            PotThree.setImage(ramenImage[2], for: .normal)
        }
        else if(ingredientHolding == "noodle" && ramenStatus[2] == "soup"){
            print("noodle -> 냄비3")
            ramenStatus[2] = "noodle"
            PotThree.setImage(ramenImage[3], for: .normal)
        }
        else if(ingredientHolding == "green" && ramenStatus[2] == "noodle"){
            print("green -> 냄비3")
            ramenStatus[2] = "green"
            PotThree.setImage(ramenImage[4], for: .normal)
        }
        else if(ingredientHolding == "egg" && ramenStatus[2] == "green"){
            print("egg -> 냄비3")
            ramenStatus[2] = "egg"
            PotThree.setImage(ramenImage[5], for: .normal)
        }
        else if(ramenStatus[2] == "egg"){
            //점수 올리기
            score += 1000
            scoreText.text = "\(score)"
            //라면 냄비 rest시키기
            ramenStatus[2] = "0"
            PotThree.setImage(ramenImage[0], for: .normal)
            timer3.invalidate()
            timerCounting[2]  = false
            PotThreeTime = 0
        }else if(ramenStatus[2] == "burnt"){
            PotThree.setImage(ramenImage[0], for: .normal)
            ramenStatus[2] = "0"
        }else{
            print("순서가 잘못되었습니다")
        }
        
    }
    
    
//MARK - 라면 냄비 4
    
    var timer4 = Timer()
    var PotFourTime = 0
    
    @objc func PotFourCount(){
        PotFourTime = PotFourTime + 1
        if(PotFourTime < 15){
            print("4번 냄비 남은 게임 시간 : " + String(15-PotFourTime) + "초")
        }
        else{
            timer4.invalidate()
            print("4번 냄비 탐")
            timerCounting[3]  = false
            ramenStatus[3] = "burnt"
            PotFourTime = 0
            DispatchQueue.main.sync {
                PotFour.setImage(ramenImage[6], for: .normal)
            }
            
        }
    }
    
    @IBAction func PotFour(_ sender: Any) {
        if (ingredientHolding == "water" && ramenStatus[3] == "0"){
            print("water -> 냄비4")
            ramenStatus[3] = "water"
            print(ramenStatus[3])
            PotFour.setImage(ramenImage[1], for: .normal)
            
            //타이머 시작
            DispatchQueue.global(qos: .userInitiated).async { [self] in
                timerCounting[3] = true
                let runLoop = RunLoop.current
                timer4 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PotFourCount), userInfo: nil, repeats: true)
                
                while timerCounting[3]{
                    runLoop.run(until: Date().addingTimeInterval(0.1))
                }
            }
        }
        else if (ingredientHolding == "soup" && ramenStatus[3] == "water"){
            print("soup -> 냄비4")
            ramenStatus[3] = "soup"
            print(ramenStatus[3])
            PotFour.setImage(ramenImage[2], for: .normal)
        }
        else if(ingredientHolding == "noodle" && ramenStatus[3] == "soup"){
            print("noodle -> 냄비4")
            ramenStatus[3] = "noodle"
            PotFour.setImage(ramenImage[3], for: .normal)
        }
        else if(ingredientHolding == "green" && ramenStatus[3] == "noodle"){
            print("green -> 냄비4")
            ramenStatus[3] = "green"
            PotFour.setImage(ramenImage[4], for: .normal)
        }
        else if(ingredientHolding == "egg" && ramenStatus[3] == "green"){
            print("egg -> 냄비4")
            ramenStatus[3] = "egg"
            PotFour.setImage(ramenImage[5], for: .normal)
        }
        else if(ramenStatus[3] == "egg"){
            //점수 올리기
            score += 1000
            scoreText.text = "\(score)"
            
            //라면 냄비 rest시키기
            ramenStatus[3] = "0"
            PotFour.setImage(ramenImage[0], for: .normal)
            timer4.invalidate()
            timerCounting[3]  = false
            PotFourTime = 0
        }else if(ramenStatus[3] == "burnt"){
            PotFour.setImage(ramenImage[0], for: .normal)
            ramenStatus[3] = "0"
            print("냄비 바꿔줌")
            
        }else{
            print("순서가 잘못되었습니다")
        }
        
    }
}

