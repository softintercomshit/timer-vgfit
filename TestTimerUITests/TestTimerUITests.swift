//
//  TestTimerUITests.swift
//  TestTimerUITests
//
//  Created by Andrei on 12/13/17.
//  Copyright © 2017 SoftIntercom. All rights reserved.
//

import XCTest

class TestTimerUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
       start()
    }
    
    func start() {
        let app = XCUIApplication()
        let tabbarQuery = app.tabBars
//        tabbarQuery.buttons.element(boundBy: 1).tap()
//        app.buttons["ic btn play"].tap()
//        sleep(7)
//        snapshot("RoundsPortrait")
        
        tabbarQuery.buttons.element(boundBy: 0).tap()
        sleep(1)
        print("----->\(app.buttons.allElementsBoundByIndex)")
        app.buttons["ic btn play"].tap()
        //        print("---->>>>>>\(app.buttons["ic btn play"].frame)")
        sleep(1)
        app.buttons["ic btn play"].tap()
        sleep(2)
        snapshot("PortraitScreen")
        
        app.buttons["ic btn play"].tap()
        XCUIDevice.shared.orientation = .landscapeLeft
        sleep(15)
        app.buttons["ic btn play"].tap()
        sleep(2)
        snapshot("LandscapeScreen")
        sleep(2)
        
        XCUIDevice.shared.orientation = .portrait
        sleep(1)
        app.buttons.element(boundBy: 5).tap()
        
        let firstCell = app.tables.cells.element(boundBy: 0)
        let start = firstCell.coordinate(withNormalizedOffset: CGVector(dx:0, dy:0))
        let finish = firstCell.coordinate(withNormalizedOffset: CGVector(dx:0, dy:-1.05))
        start.press(forDuration: 0, thenDragTo: finish)
        sleep(2)
        snapshot("TabataIntervalsScroll")
        //        sleep(4)
        //        app.swipeUp()
        //        sleep(1)
        //        app.swipeDown()
        sleep(4)
    }
    
}
