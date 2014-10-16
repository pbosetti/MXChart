//
//  ViewController.swift
//  MXChartTest
//
//  Created by Paolo Bosetti on 11/10/14.
//  Copyright (c) 2014 University of Trento. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
  @IBOutlet var chartView: MXChartView!
  @IBOutlet weak var simulateSwitch: UISwitch!
  @IBOutlet weak var info: UILabel!
  
  @IBAction func toggle(sender: UITapGestureRecognizer) {
    self.active = !self.active
  }
  
  var count: Int64 = 0
  var active: Bool = false
  var queue = NSOperationQueue()
  let motionManager = CMMotionManager()
  let frequency = 30.0
  var timer = NSTimer()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    chartView.addSeries("x", withLabel: "X acc")
    chartView.series["x"]?.lineWidth = 1
    chartView.series["x"]?.capacity = 100
    chartView.addSeries("y", withLabel: "Y acc")
    chartView.series["y"]?.lineWidth = 1
    chartView.series["y"]?.capacity = 100
    chartView.series["y"]?.lineColor = UIColor.blueColor()
    chartView.addSeries("z", withLabel: "Z acc")
    chartView.series["z"]?.lineWidth = 1
    chartView.series["z"]?.capacity = 100
    chartView.series["z"]?.lineColor = UIColor.greenColor()
    count = 0
    
    if (motionManager.accelerometerAvailable) {
      println("Starting accelerometer data collection")
      motionManager.accelerometerUpdateInterval = 1.0 / frequency
      motionManager.startAccelerometerUpdatesToQueue(queue) { accelerometerData, error in
        if (self.active) {
          self.chartView.addPointToSerie("x", x: CGFloat(self.count), y: CGFloat(accelerometerData.acceleration.x) )
          self.chartView.addPointToSerie("y", x: CGFloat(self.count), y: CGFloat(accelerometerData.acceleration.y) )
          self.chartView.addPointToSerie("z", x: CGFloat(self.count), y: CGFloat(accelerometerData.acceleration.z) )
          self.count++
        }
      }
    }
    
    NSTimer.scheduledTimerWithTimeInterval(1.0 / frequency, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func update() {
    if (active) {
      if (simulateSwitch.on) {
        let x = CGFloat(rand()) / CGFloat(RAND_MAX) * 2 - 1
        let y = CGFloat(rand()) / CGFloat(RAND_MAX) * 2 - 1
        let z = CGFloat(rand()) / CGFloat(RAND_MAX) * 2 - 1
        chartView.addPointToSerie("x", x: CGFloat(count), y: x)
        chartView.addPointToSerie("y", x: CGFloat(count), y: y)
        chartView.addPointToSerie("z", x: CGFloat(count), y: z)
        count++
      }
      chartView.autoRescaleOnSerie("x", axes: (true, false))
    }
  }
  
  override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
    chartView.setNeedsDisplay()
  }
}

