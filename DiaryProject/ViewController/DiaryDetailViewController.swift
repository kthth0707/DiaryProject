//
//  DiaryDetailViewController.swift
//  DiaryProject
//
//  Created by TH on 2022/07/18.
//

import UIKit

class DiaryDetailViewController: UIViewController {
    
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var textViewContents: UITextView!
    @IBOutlet var labelDate: UILabel!
    
    var diary: Diary? = nil
    var indexPath: IndexPath? = nil
    var buttonStar: UIBarButtonItem? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureView()
        NotificationCenter.default.addObserver(self, selector: #selector(starDiaryNotification(_:)), name: NSNotification.Name("starDiary"), object: nil)
        
    }
    
    private func configureView() {
        guard let diary = self.diary else { return }
        self.labelTitle.text = diary.title
        self.textViewContents.text = diary.contents
        self.labelDate.text = Singleton.singleton.dateToString(date: diary.date, type: "yy년 MM월 dd일(EEEEE)")
        self.buttonStar = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(tapStarButton))
        self.buttonStar?.image = diary.isStar ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        self.buttonStar?.tintColor = .orange
        self.navigationItem.rightBarButtonItem = self.buttonStar
        
    }
    
    @objc func starDiaryNotification(_ notification: Notification) {
        guard let starDiary = notification.object as? [String:Any] else { return }
        guard let isStar = starDiary["isStar"] as? Bool else { return }
        guard let uuidString = starDiary["uuidString"] as? String else { return }
        guard let diary = self.diary else { return }
        if diary.uuidString == uuidString {
            self.diary?.isStar = isStar
            self.configureView()
        }
        
    }
    
    @objc func editDiaryNotification(_ notification: Notification) {
        guard let diary = notification.object as? Diary else { return  }
        self.diary = diary
        self.configureView()
    }
                                          
    @objc func tapStarButton() {
        
        if self.diary?.isStar ?? false {
            self.diary?.isStar = false
        } else {
            self.diary?.isStar = true
        }
        
        guard let isStar = self.diary?.isStar else { return }
        guard let indexPath = self.indexPath else { return }
        
        self.buttonStar?.image = isStar ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        NotificationCenter.default.post(
            name: NSNotification.Name("starDiary"),
            object: [
                "diary": self.diary,
                "isStar": self.diary?.isStar ?? false,
                "uuidString": diary?.uuidString
            ],
            userInfo: nil
        )
    }
    
    @IBAction func onClikcCorrection(_ sender: UIButton) {
        guard let writeDiaryViewController = self.storyboard?.instantiateViewController(withIdentifier: "WriteDiaryViewController") as? WriteDiaryViewController else { return }
        if let indexPath = self.indexPath, let diary = self.diary {
            writeDiaryViewController.diaryEditorMode = .edit(indexPath, diary)
        } else {
            print("nil이 발견되었습니다(onClikcCorrection)")
        }
        // NotificationCenter 받는 방법
        NotificationCenter.default.addObserver(self, selector: #selector(editDiaryNotification(_:)), name: NSNotification.Name("editDiary"), object: nil)
        self.navigationController?.pushViewController(writeDiaryViewController, animated: true)
    }
    
    @IBAction func onClickDelete(_ sender: UIButton) {
        guard let uuidString = self.diary?.uuidString else { return }
        self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(
            name: NSNotification.Name("deleteDiary"),
            object: uuidString,
            userInfo: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}
