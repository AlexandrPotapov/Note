//
//  ColorPickerViewController.swift
//  Note
//
//  Created by Александр on 17.01.2021.
//  Copyright © 2021 lancelap. All rights reserved.
//

import UIKit
import Foundation

protocol CPVCDelegate: class {
    func getPickColor(pickColor: UIColor)
}

class ColorPickerViewController: UIViewController, HSBColorPickerDelegate, ColorPickerViewDelegate {
    
    
    
    weak var colorPicker: ColorPicker!
    var color: UIColor!
    var colorCode: String!
    
    weak var delegate: CPVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let colorPicker = getColorPicker() else { return }
        self.colorPicker = colorPicker
        if self.color != nil {
            self.colorPicker.currentColor.backgroundColor = self.color
            self.colorPicker.colorCode.text = self.colorCode
        }
        self.view.addSubview(self.colorPicker)
        self.colorPicker.translatesAutoresizingMaskIntoConstraints = false
        self.colorPicker.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.colorPicker.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.colorPicker.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.colorPicker.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }

    func HSBColorColorPickerTouched(sender: ColorPalitte, color: UIColor, point: CGPoint, state: UIGestureRecognizer.State) {
        self.color = color
        colorPicker.currentColor.backgroundColor = color
        colorPicker.colorCode.text = "#" + String(color.toHex() ?? "error")
    }

    func clickedDoneButton() {
        if color == nil {
            color = UIColor(hex: "3DC440FF") ?? .green
        }
        self.delegate?.getPickColor(pickColor: color)
        // go back to the previous view controller
        _ = self.navigationController?.popViewController(animated: true)
    }
    func getColorPicker() -> ColorPicker? {
        guard let colorPicker = ColorPicker.instanceFromNib() else { return nil }
        if let palitte = colorPicker.colorPalitte as? ColorPalitte {
            palitte.delegate = self
        }
        colorPicker.delegate = self
        return colorPicker
    }

}


extension ColorPickerViewController {
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       
       AppUtility.lockOrientation(.portrait)
   }

   override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
    
       AppUtility.lockOrientation(.all)
   }
}
