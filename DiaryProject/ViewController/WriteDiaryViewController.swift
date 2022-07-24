//
//  WriteDiaryViewController.swift
//  DiaryProject
//
//  Created by TH on 2022/07/18.
//

import UIKit

enum DiaryEditorMode {
    case new
    case edit(IndexPath, Diary)
}

protocol WriteDiaryDelegate: AnyObject {
    func didSelctReigster(diary: Diary)
}


class WriteDiaryViewController: UIViewController {
    
    @IBOutlet var textFieldWrite: UITextField!
    @IBOutlet var textViewWrite: UITextView!
    @IBOutlet var textFieldDate: UITextField!
    @IBOutlet var buttonRegister: UIBarButtonItem!
    
    private let datePicker = UIDatePicker()
    private var diaryDate: Date? = nil
    var diaryEditorMode: DiaryEditorMode = .new
    weak var delegate: WriteDiaryDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureContentsTextView()
        self.configureDatePicker()
        self.configureInputField()
        
        self.configureEditMode()
        
        //버튼 비활성화
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
    
    @objc private func textFieldWriteDidChange(_ sender: UIDatePicker) {
        self.vaildateInputField()
    }
    
    @objc private func dateTextFieldDidchange(_ sender: UITextField) {
        self.vaildateInputField()
    }
    
    private func configureInputField() {
        self.textViewWrite.delegate = self
        self.textFieldWrite.addTarget(self, action: #selector(textFieldWriteDidChange(_:)), for: .editingChanged)
        self.textFieldDate.addTarget(self, action: #selector(dateTextFieldDidchange(_:)), for: .editingChanged)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func vaildateInputField() {
        // 텍스트필드와 date텍스트필드에 값이 있을때
        // 버튼 기능 활성화
        self.buttonRegister.isEnabled = !(self.textFieldWrite?.text?.isEmpty ?? true) && !(self.textFieldDate?.text?.isEmpty ?? true) && !self.textViewWrite.text.isEmpty
    }
    
    @objc private func tapConfirmButton(_ sender: UIDatePicker) {
        
        self.diaryDate = datePicker.date
        self.textFieldDate.text = Singleton.singleton.dateToString(date: datePicker.date, type: "yyyy년 MM월 dd일(EEEEE)")
        self.textFieldDate.sendActions(for: .editingChanged)
    }
    
    private func configureEditMode() {
        switch self.diaryEditorMode {
        // https://townpharm.tistory.com/12
        case let .edit(_, diary) :
            self.textFieldWrite.text = diary.title
            self.textViewWrite.text = diary.contents
            self.textFieldDate.text = Singleton.singleton.dateToString(date: diary.date, type: "yy년 MM월 dd일(EEEEE)")
            self.diaryDate = diary.date
            self.buttonRegister.title = "수정"
            return
            
        default :
            break
        }
    }
    
    @IBAction func onClickregister(_ sender: UIBarButtonItem) {
        guard let title = self.textFieldWrite.text else { return }
        guard let contents = self.textViewWrite.text else { return }
        guard let date = self.diaryDate else { return }
        let diary = Diary(title: title, contents: contents, date: date, isStar: false)
        
        switch self.diaryEditorMode {
        case .new :
            self.delegate?.didSelctReigster(diary: diary)
            
        case let .edit(indexPath, _):
            // NotificationCenter 쓰는 방법
            NotificationCenter.default.post(
                name: NSNotification.Name("editDiary"),
                object: diary,
                userInfo: [
                    "indexPath.row": indexPath.row
                ])
        }
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
}

extension WriteDiaryViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.vaildateInputField()
    }
}
