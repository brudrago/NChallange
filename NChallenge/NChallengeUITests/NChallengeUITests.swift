import XCTest

final class NChallengeUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - UI Element Tests
    
    func test_initialState_shouldShowCorrectElements() throws {
        let textField = app.textFields["home.textField"]
        let button = app.buttons["home.sendButton"]
        let tableView = app.tables["home.tableView"]
        
        XCTAssertTrue(textField.exists, "Text field should exist")
        XCTAssertTrue(button.exists, "Button should exist")
        XCTAssertTrue(tableView.exists, "Table view should exist")
        
        // Check for button initial state
        XCTAssertFalse(button.isEnabled, "Button should be disabled initially")
        XCTAssertEqual(button.label,"Send", "Button should have correct title")
        
        // Check textfield placeholder
        XCTAssertEqual(textField.placeholderValue, "Enter a URL", "Text field should have correct placeholder")
    }
    
    func test_textFieldInput_shouldEnableButtonWhenValid() throws {
        let textField = app.textFields["home.textField"]
        let button = app.buttons["home.sendButton"]
        
        // Wait for elements to be ready
        XCTAssertTrue(textField.waitForExistence(timeout: 5), "Text field should exist")
        XCTAssertTrue(button.waitForExistence(timeout: 5), "Button should exist")
        
        // disabled button initially
        XCTAssertFalse(button.isEnabled, "Button should be disabled initially")
        
        // Test with short text (less than 5 characters)
        textField.tap()
       // textField.clearText()
        textField.typeText("http")
        
        // Wait for button to remain disabled
        XCTAssertTrue(button.waitForDisabled(timeout: 2), "Button should remain disabled with short text")
        
        // Test with valid text (5+ characters)
        textField.clearText()
        textField.typeText("https://example.com")
        
        // Wait for button to become enabled
        XCTAssertTrue(button.waitForEnabled(timeout: 2), "Button should be enabled with valid text")
    }
    
    func test_tableView_shouldShowEmptyStateInitially() throws {
        let tableView = app.tables.firstMatch
        
        XCTAssertTrue(tableView.exists, "Table view should exist")
        XCTAssertEqual(tableView.cells.count, 0, "Table view should be empty initially")
    }
    
    func test_keyboard_shouldDismissWhenReturnPressed() throws {
        let textField = app.textFields["home.textField"]
        
        textField.tap()
        textField.typeText("https://example.com")
        
        // Check if keyboard is visible
        XCTAssertTrue(app.keyboards.firstMatch.exists, "Keyboard should be visible")
        
        // Press return
        textField.typeText("\n")
        
        // Check if keyboard is dismissed
        XCTAssertFalse(app.keyboards.firstMatch.exists, "Keyboard should be dismissed")
    }
    
    func test_orientation_shouldWorkInBothOrientations() throws {
        let textField = app.textFields["home.textField"]
        let button = app.buttons["home.sendButton"]
        
        // portrait
        XCUIDevice.shared.orientation = .portrait
        XCTAssertTrue(textField.exists, "Text field should exist in portrait")
        XCTAssertTrue(button.exists, "Button should exist in portrait")
        
        // landscapeLeft
        XCUIDevice.shared.orientation = .landscapeLeft
        XCTAssertTrue(textField.exists, "Text field should exist in landscape")
        XCTAssertTrue(button.exists, "Button should exist in landscape")
        
        XCUIDevice.shared.orientation = .portrait
    }
}

extension XCUIElement {
    func clearText() {
        guard let stringValue = self.value as? String, !stringValue.isEmpty else {
            return
        }
        
        // Double tap to select all text
        self.doubleTap()
        
        // Then delete it
        self.typeText(XCUIKeyboardKey.delete.rawValue)
    }
    
    func waitForEnabled(timeout: TimeInterval = 5) -> Bool {
        let predicate = NSPredicate(format: "enabled == true")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        return XCTWaiter().wait(for: [expectation], timeout: timeout) == .completed
    }
    
    func waitForDisabled(timeout: TimeInterval = 5) -> Bool {
        let predicate = NSPredicate(format: "enabled == false")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        return XCTWaiter().wait(for: [expectation], timeout: timeout) == .completed
    }
    
}
