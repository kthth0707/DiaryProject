//
//  ViewController.swift
//  DiaryProject
//
//  Created by TH on 2022/07/18.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var collectionViewDiary: UICollectionView!
    @IBOutlet var viewDiaryAdd: UIView!
    
    private var diaryList = [Diary]() {
        didSet {
            self.viewDiaryAdd.isHidden = !self.diaryList.isEmpty
            self.saveDiaryList()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.viewDiaryAdd.isHidden = !self.diaryList.isEmpty
        self.configureCollectionView()
        self.loadDiaryList()
        
        NotificationCenter.default.addObserver(self, selector: #selector(editNotification(_:)), name: NSNotification.Name("editDiary"), object: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let writeDiaryViewController = segue.destination as? WriteDiaryViewController {
            writeDiaryViewController.delegate = self
        }
    }
    
    @objc func editNotification(_ notifocation: Notification) {
        guard let diary = notifocation.object as? Diary else { return }
        guard let row = notifocation.userInfo?["indexPath.row"] as? Int else { return }
        self.diaryList[row] = diary
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        self.collectionViewDiary.reloadData()
    }
    
    private func configureCollectionView() {
        self.collectionViewDiary.collectionViewLayout = UICollectionViewFlowLayout()
        self.collectionViewDiary.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.collectionViewDiary.delegate = self
        self.collectionViewDiary.dataSource = self
    }
    
    private func loadDiaryList() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "diaryList") as? [[String:Any]] else { return }
        self.diaryList = data.compactMap {
            guard let title = $0["title"] as? String else { return nil }
            guard let contents = $0["contents"] as? String else { return nil }
            guard let date = $0["date"] as? Date else { return nil }
            guard let isStar = $0["isStar"] as? Bool else { return nil }
            
            return Diary(title: title, contents: contents, date: date, isStar: isStar)
        }
        
        //최신순으로 정렬
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
    }
    
    private func saveDiaryList() {
        let date = self.diaryList.map {
            [
                "title": $0.title,
                "contents": $0.contents,
                "date": $0.date,
                "isStar": $0.isStar
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(date, forKey: "diaryList")
    }
}

extension ViewController: DiaryDetailViewDelegate {
    func didSelectDelete(indexPath: IndexPath) {
        self.diaryList.remove(at: indexPath.row)
        self.collectionViewDiary.deleteItems(at: [indexPath])
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.diaryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let diary = self.diaryList[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCell else { return UICollectionViewCell() }
        cell.initSetting(item: diary)
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / 2 - 20), height: 200)
    }
}

extension ViewController: UICollectionViewDelegate {
    
    // 특정 셀 버튼 클릭 인식
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let diaryDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
        diaryDetailViewController.delegate = self
        diaryDetailViewController.diary = self.diaryList[indexPath.row]
        diaryDetailViewController.indexPath = indexPath
        self.navigationController?.pushViewController(diaryDetailViewController, animated: true)
    }
}

extension ViewController: WriteDiaryDelegate {
    func didSelctReigster(diary: Diary) {
        self.diaryList.append(diary)
        self.diaryList = self.diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        self.collectionViewDiary.reloadData()
    }
}


