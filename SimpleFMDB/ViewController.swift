//
//  ViewController.swift
//  SimpleFMDB
//
//  Created by Hiroshi Tanaka on 2016/12/07.
//  Copyright © 2016年 Hiroshi Tanaka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    let fileURL = try! FileManager.default
      .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
      .appendingPathComponent("test.sqlite")
    
    guard let database = FMDatabase(path: fileURL.path) else {
      print("unable to create database")
      return
    }
    
    guard database.open() else {
      print("Unable to open database")
      return
    }
    
    do {
      try database.executeUpdate("create table test(x text, y text, z text)", values: nil)
      try database.executeUpdate("insert into test (x, y, z) values (?, ?, ?)", values: ["a", "b", "c"])
      try database.executeUpdate("insert into test (x, y, z) values (?, ?, ?)", values: ["e", "f", "g"])
    } catch {
      print("failed: \(error.localizedDescription)")
    }
    
    do {
      let rs = try database.executeQuery("select x, y, z from test", values: nil)
      while rs.next() {
        if let x = rs.string(forColumn: "x"), let y = rs.string(forColumn: "y"), let z = rs.string(forColumn: "z") {
          print("x = \(x); y = \(y); z = \(z)")
        }
      }
    } catch {
      print("failed: \(error.localizedDescription)")
    }
    
    database.close() 
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

