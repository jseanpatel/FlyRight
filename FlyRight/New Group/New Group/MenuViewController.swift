//
//  GameViewController.swift
//  FlyRight
//
//  Created by Jacob Patel on 1/4/18.
//  Copyright © 2017 Jacob Patel. All rights reserved.
//
import UIKit
import SpriteKit
import AVFoundation
import Firebase

// Variable to control playing of music.
var audioPlayer: AVAudioPlayer!

 var soundPlayer: AVAudioPlayer!

class MenuViewController: UIViewController {

    // The scene draws the tiles and space sprites, and handles actions (swipes for CC).
    var scene: MenuScene!

    // References back to the old viewControllers so that they can be dismissed.
    var optionsVC: OptionsViewController!
    
    // For recognizing gestures.
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    // MARK: View Controller Functions

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBAction func moveToGame(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "toGameSegue", sender: nil)
        AVAudioPlayer.playSpecAudio(audioPiece: "Click", volume: 0.7)
    }

    @IBAction func moveToCredits(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "toCreditsSegue", sender: nil)
         AVAudioPlayer.playSpecAudio(audioPiece: "Click", volume: 0.7)
    }

    @IBAction func moveToOptions(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "toOptionsSegue", sender: nil)
         AVAudioPlayer.playSpecAudio(audioPiece: "Click", volume: 0.7)
    }


    @IBAction func moveToRecords(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.performSegue(withIdentifier: "toRecordsSegue", sender: nil)
         AVAudioPlayer.playSpecAudio(audioPiece: "Click", volume: 0.7)
    }


    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.portrait, .portraitUpsideDown]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
        if optionsVC != nil {
            print("here")
        // Dismiss the previous VC's.
        self.dismiss(animated: false, completion: nil)
        }
 */

        bannerView.adUnitID = ""
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        UserDefaults.isFirstLaunchMenu()

        // Configure the view.
        let skView = view as! SKView
        skView.isMultipleTouchEnabled = false

        // Create and configure the scene.
        scene = MenuScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill

        // Present the scene.
        skView.presentScene(scene)
    }
}

// Extension to check when the first true start of the app is so defaults can be set.
extension UserDefaults {

    // Check for is first launch - only true on first invocation after app install, false on all further invocations.
    static func isFirstLaunchMenu() {

        let launchedBeforeMenu = UserDefaults.standard.bool(forKey: "launchedBeforeMenu")
        if launchedBeforeMenu {
            if (UserDefaults.standard.bool(forKey: "shouldPlay")) {
                if !(UserDefaults.standard.bool(forKey: "isPlaying")) {

                    // Set path to music.
                    let url = Bundle.main.url(forResource: "Chimera", withExtension: "mp3")

                    // Instantiate the musicPlayer object and catch errors if they arise.
                    do {
                        audioPlayer = try AVAudioPlayer(contentsOf: url!)
                        audioPlayer.prepareToPlay()
                    } catch let error as NSError {
                        print(error.debugDescription)
                    }
                    audioPlayer.numberOfLoops = -1
                    audioPlayer.volume = 0.9

                    audioPlayer.play()
                    UserDefaults.standard.set(true, forKey: "isPlaying")
                    UserDefaults.standard.set(false, forKey: "shouldPlay")
                }
            } else {

                if !(UserDefaults.standard.bool(forKey: "isPlaying")) {
                    // Set path to music.
                    let url = Bundle.main.url(forResource: "Chimera", withExtension: "mp3")

                    // Instantiate the musicPlayer object and catch errors if they arise.
                    do {
                        audioPlayer = try AVAudioPlayer(contentsOf: url!)
                        audioPlayer.prepareToPlay()
                    } catch let error as NSError {
                        print(error.debugDescription)
                    }
                    audioPlayer.numberOfLoops = -1

                    print("here")
                    audioPlayer.pause()

                    UserDefaults.standard.set(true, forKey: "isPlaying")
                    UserDefaults.standard.set(false, forKey: "shouldPlay")
                }
            }
        } else {

            // Ensure the game is always downloaded with sounds on.
            UserDefaults.standard.set(true, forKey: "shouldMakeSounds")

            // Set path to music.
            let url = Bundle.main.url(forResource: "Chimera", withExtension: "mp3")

            // Instantiate the musicPlayer object and catch errors if they arise.
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url!)
                audioPlayer.prepareToPlay()
            } catch let error as NSError {
                print(error.debugDescription)
            }
            audioPlayer.numberOfLoops = -1

            // Set the starting time which will be changed later to account for pauses.
            UserDefaults.standard.set(0, forKey: "start")
            
            UserDefaults.standard.set(true, forKey: "musicSwitchState")
            UserDefaults.standard.set(true, forKey: "soundSwitchState")

            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBeforeMenu")
            UserDefaults.standard.set(true, forKey: "shouldPlay")

            audioPlayer.volume = 0.9
            
            // Play the music.
            audioPlayer.play()

            // Record the start time of the music.
            let timeStart = Double(DispatchTime.now().uptimeNanoseconds)
            UserDefaults.standard.set(timeStart, forKey: "timeStart")

            audioPlayer.numberOfLoops = -1
            UserDefaults.standard.set(true, forKey: "isPlaying")
        }
    }
}


extension AVAudioPlayer {
    
    // Variable to control playing of sounds.
    
    /// Takes the specific mp3 file and volume to play sound.
    static func playSpecAudio(audioPiece: String, volume: Float) {
        if (UserDefaults.standard.bool(forKey: "shouldMakeSounds" )) {
            
            // Set path to music.
            let url = Bundle.main.url(forResource: audioPiece, withExtension: "mp3")
            
            // Instantiate the musicPlayer object and catch errors if they arise.
            do {
                soundPlayer = try AVAudioPlayer(contentsOf: url!)
                soundPlayer.prepareToPlay()
            } catch let error as NSError {
                print("error in instantiating soundAudioPlayer")
            }
            soundPlayer.volume = volume
            soundPlayer.play()
        }
    }
}





