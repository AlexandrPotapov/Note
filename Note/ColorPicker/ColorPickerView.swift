import UIKit
protocol ColorPickerViewDelegate: class {

    func clickedDoneButton()
}

class ColorPicker: UIView {
    @IBOutlet weak var colorPalitte: UIView!
    @IBOutlet weak var currentColor: UIView!
    @IBOutlet weak var colorCode: UILabel!
    @IBOutlet weak var containerView: UIView! { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    weak var delegate: ColorPickerViewDelegate?
    
    class func instanceFromNib() -> ColorPicker? {
        guard let colorPicker = Bundle.main.loadNibNamed("ColorPickerView", owner: self, options: nil)?.first as? ColorPicker else { return nil }
        return colorPicker
    }
    
    override func draw(_ rect: CGRect) {
        containerView.layer.cornerRadius = 16
        containerView.layer.masksToBounds = true
        
    }

    @IBAction func pickButton(_ sender: UIButton) {
        self.delegate?.clickedDoneButton()
    }
    
    
    
}
