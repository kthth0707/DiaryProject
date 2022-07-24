//
//  DiaryCell.swift
//  DiaryProject
//
//  Created by TH on 2022/07/18.
//

import UIKit

class DiaryCell: UICollectionViewCell {
    
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var labelDate: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.contentView.layer.cornerRadius = 3.0
        self.contentView.layer.borderWidth = 3.0
        self.contentView.layer.borderColor = UIColor.black.cgColor
    }
    
    func initSetting(item: Diary) {
        self.labelTitle.text = item.title
        self.labelDate.text = Singleton.singleton.dateToString(date: item.date, type: "yy년 MM월 dd일(EEEEE)")
        
    }
}
