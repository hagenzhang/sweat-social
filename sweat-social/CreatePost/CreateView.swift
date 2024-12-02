import UIKit

class CreateView: UIView, UITextViewDelegate {
    var selectPic: UIButton!
    let createView = UITextView()
    let totalTimeLabel = UILabel()
    let hoursTextField = UITextField()
    let minutesTextField = UITextField()
    let locationLabel = UILabel()
    let locationTextField = UITextField()
    let placeholderText = "Enter details here (Optional)"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSelectPic()
        setupTotalTimeRow()
        setupLocationRow()
        setupCreateTextView()
        initConstraints()
    }

    func setupSelectPic(){
        selectPic = UIButton(type: .system)
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

        locationTextField.placeholder = "Enter location (Optional)"
        locationTextField.borderStyle = .roundedRect
        locationTextField.font = UIFont.systemFont(ofSize: 16)
        locationTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(locationTextField)
    }
    
    func setupCreateTextView() {
        createView.layer.borderColor = UIColor.gray.cgColor
        createView.layer.borderWidth = 1
        createView.layer.cornerRadius = 8
        createView.font = UIFont.systemFont(ofSize: 16)
        createView.text = self.placeholderText
        createView.textColor = .lightGray
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


            locationLabel.topAnchor.constraint(equalTo: totalTimeLabel.bottomAnchor, constant: 20),
            locationLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            locationLabel.widthAnchor.constraint(equalToConstant: 100),

            locationTextField.centerYAnchor.constraint(equalTo: locationLabel.centerYAnchor),
            locationTextField.leadingAnchor.constraint(equalTo: locationLabel.trailingAnchor, constant: 8),
            locationTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            hoursTextField.centerYAnchor.constraint(equalTo: totalTimeLabel.centerYAnchor),
            hoursTextField.leadingAnchor.constraint(equalTo: locationTextField.leadingAnchor),
            hoursTextField.widthAnchor.constraint(equalTo: locationTextField.widthAnchor, multiplier: 0.49),

            minutesTextField.centerYAnchor.constraint(equalTo: totalTimeLabel.centerYAnchor),
            minutesTextField.trailingAnchor.constraint(equalTo: locationTextField.trailingAnchor),
            minutesTextField.widthAnchor.constraint(equalTo: locationTextField.widthAnchor, multiplier: 0.49),
            
            minutesTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),

            createView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 16),
            createView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            createView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            createView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -32)
        ])
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == self.placeholderText {
            textView.text = ""
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = self.placeholderText
            textView.textColor = .lightGray
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
