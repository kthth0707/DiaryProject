//
//  WriteDiaryViewController.swift
//  DiaryProject
//
//  Created by TH on 2022/07/18.
//

import UIKit

class WriteDiaryViewController: UIViewController {
    
    @IBOutlet var textTieldWrite: UITextField!
    @IBOutlet var textViewWrite: UITextView!
    @IBOutlet var textFieldDate: UITextField!
    @IBOutlet var buttonRegister: UIBarButtonItem!
    
    private let datePicker = UIDatePicker()
    private var diaryDate: Date? = nil
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureContentsTextView()
        self.configureDatePicker()
        self.configureInputField()
        self.buttonRegister.isEnabled = false
        
    }
    
    // 테두리에만 색 넣는 방법
    private func configureContentsTextView() {
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        self.textViewWrite.layer.borderColor = borderColor.cgColor
        self.textViewWrite.layer.borderWidth = 0.5
        self.textViewWrite.layer.cornerRadius = 5.0
    }
    
    private func configureDatePicker() {
        // 날짜만 나오게
        self.datePicker.datePickerMode = .date
        // 스타일
        self.datePicker.preferredDatePickerStyle = .wheels
        self.datePicker.addTarget(self, action: #selector(tapConfirmButton(_:)), for: .valueChanged)
        self.datePicker.locale = Locale(identifier: "ko-KR")
        self.textFieldDate.inputView = self.datePicker
        
    }
    
    @objc private func tapConfirmButton(_ sender: UIDatePicker) {
        //날짜와 텍스트를 변환
        //Date -> String
        //String -> Date
        let formmater = DateFormatter()
        // E 5개는 요일
        formmater.dateFormat = "yyyy년 MM월 dd일(EEEEE)"
        formmater.locale = Locale(identifier: "ko_KR")
        self.diaryDate = datePicker.date
        self.textFieldDate.text = formmater.string(from: datePicker.date)
    }
    
    private func configureInputField() {
        self.textViewWrite.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func vaildateInputField() {
        self.buttonRegister.isEnabled = !(self.textTieldWrite?.text?.isEmpty ?? true) && !(self.textTieldWrite?.text?.isEmpty ?? true) && !self.textViewWrite.text.isEmpty
    }
    
    @IBAction func onClickregister(_ sender: UIBarButtonItem) {
        
    }
    

}

extension WriteDiaryViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.vaildateInputField()
    }
}
