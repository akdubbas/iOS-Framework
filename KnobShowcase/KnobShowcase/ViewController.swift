/// Copyright (c) 2018 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import KnobControl

class ViewController: UIViewController {
  
  @IBOutlet var valueLabel: UILabel!
  @IBOutlet var valueSlider: UISlider!
  @IBOutlet var animateSwitch: UISwitch!
  @IBOutlet var knob: Knob!

  private class RotationGestureRecognizer: UIPanGestureRecognizer {
    private(set) var touchAngle: CGFloat = 0

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
      super.touchesBegan(touches, with: event)
      updateAngle(with: touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
      super.touchesMoved(touches, with: event)
      updateAngle(with: touches)
    }

    private func updateAngle(with touches: Set<UITouch>) {
      guard let touch = touches.first, let view = view else {
        return
      }
      let touchPoint = touch.location(in: view)
      touchAngle = angle(for: touchPoint, in: view)
    }

    private func angle(for point: CGPoint, in view: UIView) -> CGFloat {
      let centerOffset = CGPoint(x: point.x - view.bounds.midX, y: point.y - view.bounds.midY)
      return atan2(centerOffset.y, centerOffset.x)
    }

    override init(target: Any?, action: Selector?) {
      super.init(target: target, action: action)

      maximumNumberOfTouches = 1
      minimumNumberOfTouches = 1
    }
  }

  
  override func viewDidLoad() {
    super.viewDidLoad()

    knob.lineWidth = 4
    knob.pointerLength = 12
    knob.setValue(valueSlider.value)
    knob.addTarget(self, action: #selector(ViewController.handleValueChanged(_:)), for: .valueChanged)
    
    updateLabel()
  }
  
  @IBAction func handleValueChanged(_ sender: Any) {
    if sender is UISlider {
      knob.setValue(valueSlider.value)
    } else {
      valueSlider.value = knob.value
    }
    updateLabel()
  }
  
  @IBAction func handleRandomButtonPressed(_ sender: Any) {
    let randomValue = Float(arc4random_uniform(101)) / 100.0
    knob.setValue(randomValue, animated: animateSwitch.isOn)
    valueSlider.setValue(Float(randomValue), animated: animateSwitch.isOn)
    updateLabel()
  }
  
  private func updateLabel() {
    valueLabel.text = String(format: "%.2f", knob.value)
  }
  
  private func getP() -> Int {
    return 2
  }
  
  fileprivate func getK() -> Int {
    return 3
  }
}

extension ViewController {
  func getHH() {
    let b = getP()
    let n = getK()
    print("\(b) - \(n)")
  }
}
