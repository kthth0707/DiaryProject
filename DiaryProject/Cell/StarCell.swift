//
//  StarCell.swift
//  DiaryProject
//
//  Created by TH on 2022/07/18.
//

import UIKit

class StarCell: UICollectionViewCell {
    
    @IBOutlet var labelTitle: UILabel!
    @IBOutlet var labelDate: UILabel!
    
    func initSetting(item : Diary) {
        labelTitle.text = item.title
        labelDate.text = Singleton.singleton.dateToString(date: item.date, type: "yy년 MM월 dd일(EEEEE)")
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.layer.cornerRadius = 3.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.black.cgColor
    }
    
    
}
