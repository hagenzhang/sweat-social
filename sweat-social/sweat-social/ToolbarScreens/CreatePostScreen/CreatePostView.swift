//
//  CreatePostView.swift
//  sweat-social
//

import UIKit

class CreateView: UIView, UITextViewDelegate {
    var selectPic = UIButton(type: .system)
    
    let createView = UITextView()
    
    let totalTimeLabel = UILabel()
    let hoursTextField = UITextField()
    let minutesTextField = UITextField()
    
    let locationLabel = UILabel()
    let locationTextField = UITextField()
    
    let captionLabel = UILabel()
    let captionTextField = UITextField()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSelectPic()
        setupTotalTimeRow()
        setupLocationRow()
        setupCaptionRow()
        setupCreateTextView()
        initConstraints()
    }

    func setupSelectPic(){
        selectPic.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        selectPic.contentHorizontalAlignment = .fill
        selectPic.contentVerticalAlignment = .fill
        selectPic.imageView?.contentMode = .scaleAspectFit
        selectPic.showsMenuAsPrimaryAction = true
        selectPic.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(selectPic)
    }
    
    func setupTotalTimeRow() {
        totalTimeLabel.text = "Total Time"
        totalTimeLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        totalTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(totalTimeLabel)

        hoursTextField.placeholder = "Hours"
        hoursTextField.borderStyle = .roundedRect
        hoursTextField.keyboardType = .numberPad
        hoursTextField.textAlignment = .center
        hoursTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(hoursTextField)

        minutesTextField.placeholder = "Minutes"
        minutesTextField.borderStyle = .roundedRect
        minutesTextField.keyboardType = .numberPad
        minutesTextField.textAlignment = .center
        minutesTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(minutesTextField)
    }
    
    func setupLocationRow() {
        locationLabel.text = "Location"
        locationLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(locationLabel)

        locationTextField.placeholder = "(optional)"
        locationTextField.borderStyle = .roundedRect
        locationTextField.font = UIFont.systemFont(ofSize: 16)
        locationTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(locationTextField)
    }
    
    func setupCaptionRow() {
        captionLabel.text = "Caption"
        captionLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(captionLabel)

        captionTextField.placeholder = "(optional)"
        captionTextField.borderStyle = .roundedRect
        captionTextField.font = UIFont.systemFont(ofSize: 16)
        captionTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(captionTextField)
        
    }
    
    func setupCreateTextView() {
        createView.layer.borderColor = UIColor.gray.cgColor
        createView.layer.borderWidth = 1
        createView.layer.cornerRadius = 8
        createView.font = UIFont.systemFont(ofSize: 16)
        createView.delegate = self
        createView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(createView)
    }

    func initConstraints() {
        NSLayoutConstraint.activate([
            selectPic.topAnchor.constraint(equalTo:self.safeAreaLayoutGuide.topAnchor, constant: 16),
            selectPic.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            selectPic.widthAnchor.constraint(equalToConstant: 100),
            selectPic.heightAnchor.constraint(equalToConstant: 100),
            
            totalTimeLabel.topAnchor.constraint(equalTo: selectPic.bottomAnchor, constant: 16),
            totalTimeLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            totalTimeLabel.widthAnchor.constraint(equalToConstant: 100),
            
            hoursTextField.centerYAnchor.constraint(equalTo: totalTimeLabel.centerYAnchor),
            hoursTextField.leadingAnchor.constraint(equalTo: locationTextField.leadingAnchor),
            hoursTextField.widthAnchor.constraint(equalTo: locationTextField.widthAnchor, multiplier: 0.49),

            minutesTextField.centerYAnchor.constraint(equalTo: totalTimeLabel.centerYAnchor),
            minutesTextField.trailingAnchor.constraint(equalTo: locationTextField.trailingAnchor),
            minutesTextField.widthAnchor.constraint(equalTo: locationTextField.widthAnchor, multiplier: 0.49),

            locationLabel.topAnchor.constraint(equalTo: totalTimeLabel.bottomAnchor, constant: 20),
            locationLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            locationLabel.widthAnchor.constraint(equalToConstant: 100),
            locationTextField.centerYAnchor.constraint(equalTo: locationLabel.centerYAnchor),
            locationTextField.leadingAnchor.constraint(equalTo: locationLabel.trailingAnchor, constant: 8),
            locationTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            captionLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 20),
            captionLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            captionLabel.widthAnchor.constraint(equalToConstant: 100),
            captionTextField.centerYAnchor.constraint(equalTo: captionLabel.centerYAnchor),
            captionTextField.leadingAnchor.constraint(equalTo: captionLabel.trailingAnchor, constant: 8),
            captionTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            createView.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 16),
            createView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            createView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            createView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -32)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
