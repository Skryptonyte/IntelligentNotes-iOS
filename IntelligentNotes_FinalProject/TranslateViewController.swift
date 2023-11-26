//
//  TranslateViewController.swift
//  IntelligentNotes_FinalProject
//
//  Created by Rayhan Faizel on 26/11/23.
//

import UIKit
import MLKitTranslate
class TranslateViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        languages.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Locale.current.localizedString(forLanguageCode: languages[row].rawValue)
    }
    let languages: [TranslateLanguage] = [.english, .hindi, .kannada, .spanish, .german, .french]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sourcePicker.delegate = self
        self.sourcePicker.dataSource = self
        self.sourcePicker.tag = 1

        self.destPicker.delegate = self
        self.destPicker.dataSource = self
        self.destPicker.tag = 2
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var sourcePicker: UIPickerView!
    @IBOutlet weak var destPicker: UIPickerView!
    var note: Note!
    var translatedText: String = ""
    @IBAction func performTranslate(_ sender: Any) {
        let srcLang =
        languages[sourcePicker.selectedRow(inComponent: 0)]
        
        let dstLang = languages[destPicker.selectedRow(inComponent: 0)]
        
        let options = TranslatorOptions(sourceLanguage: srcLang, targetLanguage: dstLang)
        let translator = Translator.translator(options: options)
        
        let conditions = ModelDownloadConditions(
            allowsCellularAccess: true,
            allowsBackgroundDownloading: true
        )
        let alert = UIAlertController(title: "Downloading translation model", message: "Please wait!", preferredStyle: .alert)
        present(alert, animated: true)
        translator.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else {
                self.dismiss(animated: true)
                print("ERROR:\(error)")
                return }
            self.dismiss(animated: true)
            translator.translate(self.note.content) { translatedText, error in
                     guard error == nil, let translatedText = translatedText else { return }
                    print(translatedText)
                self.translatedText = translatedText
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.performSegue(withIdentifier: "unwindToEdit", sender: self)
                }
                     // Translation succeeded.
                 }
        }
            // Model downloaded successfully. Okay to start translating.
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "unwindToEdit")
        {
            print("unwind")
            let vc = segue.destination as! EditNoteController
            vc.contentField.text = self.translatedText
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
