//
//  ProfileCellView.swift
//  sweat-social
//

import UIKit

class ProfileViewCell: UITableViewCell {
    var wrapperCellView: UIView!
    var cellImg: UIImageView!
    var labelTime: UILabel!
    var labelLocation: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupCellImg()
        setupLabelTime()
        setupLabelLocation()
        
        initConstraints()
    }
    
    func setupWrapperCellView(){
        wrapperCellView = UIView()

        wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.cornerRadius = 6.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
        wrapperCellView.layer.shadowRadius = 4.0
        wrapperCellView.layer.shadowOpacity = 0.2
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupCellImg() {
        cellImg = UIImageView()
        cellImg.contentMode = .scaleToFill
        cellImg.clipsToBounds = true
        cellImg.layer.cornerRadius = 10
        cellImg.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(cellImg)
    }
    
    func setupLabelTime(){
        labelTime = UILabel()
        labelTime.font = UIFont.boldSystemFont(ofSize: 20)
        labelTime.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelTime)
    }
    
    func setupLabelLocation(){
        labelLocation = UILabel()
        labelLocation.font = UIFont.boldSystemFont(ofSize: 20)
        labelLocation.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelLocation)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            
            cellImg.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            cellImg.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 8),
            cellImg.widthAnchor.constraint(equalToConstant: 60),
            cellImg.heightAnchor.constraint(equalToConstant: 60),
            
            labelTime.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            labelTime.leadingAnchor.constraint(equalTo: cellImg.trailingAnchor, constant: 12),
            labelTime.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -8),
            labelTime.heightAnchor.constraint(equalToConstant: 30),
            
            labelLocation.topAnchor.constraint(equalTo: labelTime.bottomAnchor),
            labelLocation.leadingAnchor.constraint(equalTo: cellImg.trailingAnchor, constant: 12),
            labelLocation.trailingAnchor.constraint(equalTo: wrapperCellView.trailingAnchor, constant: -8),
            labelLocation.heightAnchor.constraint(equalToConstant: 30),
            labelLocation.bottomAnchor.constraint(lessThanOrEqualTo: wrapperCellView.bottomAnchor, constant: -8),
            
        ])
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
