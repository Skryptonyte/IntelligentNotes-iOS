//
//  SpeechViewController.swift
//  IntelligentNotes_FinalProject
//
//  Created by Rayhan Faizel on 23/11/23.
//

import UIKit

class SpeechViewController: UIViewController {
    var speechRecognizer: SpeechRecognizer!
    var isRecording = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.speechRecognizer = SpeechRecognizer(delegate: self)
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var speechButton: UIButton!
    @IBOutlet weak var recordTimerLabel: UILabel!
    @IBOutlet weak var transcriptLabel: UILabel!
    var recordTimer = 0
    var timer: Timer?
    @IBAction func speechToggle(_ sender: Any) {
        isRecording.toggle()
        if (isRecording){
            speechRecognizer.startTranscribing()
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            self.transcriptLabel.text = ""
            self.recordTimerLabel.text = "00:00"
        }
        else {
            speechRecognizer.stopTranscribing()
            self.timer?.invalidate()
            self.timer = nil
            self.recordTimerLabel.text = "Not Recording"
            self.recordTimer = 0
            print(speechRecognizer.transcript)
            performSegue(withIdentifier: "folderSave", sender: self)
        }
    }
    
    @objc func updateTimer(){
        self.recordTimer += 1
        self.recordTimerLabel.text = String(format: "%02d:%02d", self.recordTimer/60, self.recordTimer%60)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "folderSave"){
            let vc = segue.destination as! FolderSelectSaveViewController
            vc.title_ = "Recorded Speech"
            vc.content = speechRecognizer.transcript
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
