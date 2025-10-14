import XCTest
@testable import NChallenge

final class HomeViewTests: XCTestCase {

    func test_initialState_buttonShouldBeDisabledWithAlpha05() {
        let (sut, _) = makeSUT()

        guard let button = sut.subviews.compactMap({ $0 as? UIButton }).first else {
            XCTFail("Button not found")
            return
        }
        
        XCTAssertFalse(button.isEnabled)
        XCTAssertEqual(button.alpha, 0.5, accuracy: 0.001)
    }

    func test_buttonEnablesWhenTextHasMinLength_andDisablesOtherwise() {
        let (sut, _) = makeSUT()
        
        guard let textField = sut.subviews.compactMap({ $0 as? UITextField }).first,
              let button = sut.subviews.compactMap({ $0 as? UIButton }).first else {
            XCTFail("Text field or button not found")
            return
        }

        //min char = 5
        textField.text = "http"
        textField.sendActions(for: .editingChanged)
        XCTAssertFalse(button.isEnabled)
        XCTAssertEqual(button.alpha, 0.5, accuracy: 0.001)

        textField.text = "https://"
        textField.sendActions(for: .editingChanged)
        XCTAssertTrue(button.isEnabled)
        XCTAssertEqual(button.alpha, 1.0, accuracy: 0.001)
    }

    func test_tapSendButton_callsDelegateAndClearsText() {
        let (sut, spy) = makeSUT()
        
        guard let textField = sut.subviews.compactMap({ $0 as? UITextField }).first,
              let button = sut.subviews.compactMap({ $0 as? UIButton }).first else {
            XCTFail("Text field or button not found")
            return
        }

        textField.text = "https://g.globo"
        textField.sendActions(for: .editingChanged)
        XCTAssertTrue(button.isEnabled)

        button.sendActions(for: .touchUpInside)

        XCTAssertEqual(spy.lastText, "https://g.globo")
        XCTAssertEqual(textField.text, "")
        XCTAssertFalse(button.isEnabled)
    }

    func test_updateShortenedURLs_reloadsTable_andHeaderTitle() {
        let (sut, _) = makeSUT()
        
        guard let tableView = sut.subviews.compactMap({ $0 as? UITableView }).first else {
            XCTFail("Table view not found")
            return
        }

        XCTAssertEqual(tableView.numberOfRows(inSection: 0), 0)

        let items = [
            ShortenedURL.fixture(
                alias: "592240651",
                originalURL: "https://www.globo.com/esporte",
                shortURL: "https://short/592240651"
            )
        ]
       
        let expectation = XCTestExpectation(description: "reload")
        
        sut.updateShortenedURLs(items)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            XCTAssertEqual(tableView.numberOfRows(inSection: 0), 1)
            
            let headerTitle = sut.tableView(tableView, titleForHeaderInSection: 0)
            XCTAssertNotNil(headerTitle)
            XCTAssertEqual(headerTitle, AppStrings.UI.recentlyShortened)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_updateShortenedURLs_withEmptyList_shouldShowEmptyTable() {
        let (sut, _) = makeSUT()
        
        guard let tableView = sut.subviews.compactMap({ $0 as? UITableView }).first else {
            XCTFail("Table view not found")
            return
        }

        let expectation = XCTestExpectation(description: "empty reload")
        
        sut.updateShortenedURLs([])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            XCTAssertEqual(tableView.numberOfRows(inSection: 0), 0)
            
            let headerTitle = sut.tableView(tableView, titleForHeaderInSection: 0)
            XCTAssertEqual(headerTitle, "")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_textFieldConfiguration() {
        let (sut, _) = makeSUT()
        
        guard let textField = sut.subviews.compactMap({ $0 as? UITextField }).first else {
            XCTFail("Text field not found")
            return
        }
        
        XCTAssertEqual(textField.placeholder, AppStrings.UI.enterURL)
        XCTAssertEqual(textField.returnKeyType, .done)
        XCTAssertEqual(textField.keyboardType, .URL)
        XCTAssertEqual(textField.autocorrectionType, .no)
        XCTAssertEqual(textField.layer.cornerRadius, 8.0, accuracy: 0.001)
    }
    
    func test_buttonConfiguration() {
        let (sut, _) = makeSUT()
        
        guard let button = sut.subviews.compactMap({ $0 as? UIButton }).first else {
            XCTFail("Button not found")
            return
        }
        
        XCTAssertEqual(button.titleLabel?.text, AppStrings.UI.sendButton)
        XCTAssertEqual(button.backgroundColor, .purple)
        XCTAssertEqual(button.layer.cornerRadius, 8.0, accuracy: 0.001)
    }
    
    //MARK: - TestHelper
    
    func makeSUT() -> (HomeView, HomeViewDelegateSpy) {
        let sut = HomeView(frame: UIScreen.main.bounds)
        sut.layoutIfNeeded()
        let spy = HomeViewDelegateSpy()
        sut.delegate = spy
        return (sut, spy)
    }
}

