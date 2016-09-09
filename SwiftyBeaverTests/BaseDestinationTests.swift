//
//  BaseDestinationTests.swift
//  SwiftyBeaver
//
//  Created by Sebastian Kreutzberger on 05.12.15.
//  Copyright © 2015 Sebastian Kreutzberger
//  Some rights reserved: http://opensource.org/licenses/MIT
//

import XCTest
@testable import SwiftyBeaver

class BaseDestinationTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testInit() {
        let obj = BaseDestination()
        XCTAssertNotNil(obj.queue)
    }


    ////////////////////////////////
    // MARK: Format
    ////////////////////////////////

    func testFormatMessage() {
        let obj = BaseDestination()
        var str = ""
        var format = ""

        // empty format
        str = obj.formatMessage(format, level: .Verbose, msg: "Hello", thread: "main",
            file: "/path/to/ViewController.swift", function: "testFunction()", line: 50)
        XCTAssertEqual(str, "")

        // format without variables
        format = "Hello"
        str = obj.formatMessage(format, level: .Verbose, msg: "Hello", thread: "main",
                                file: "/path/to/ViewController.swift", function: "testFunction()", line: 50)
        XCTAssertEqual(str, "Hello")

        // weird format
        format = "$"
        str = obj.formatMessage(format, level: .Verbose, msg: "Hello", thread: "main",
                                file: "/path/to/ViewController.swift", function: "testFunction()", line: 50)
        XCTAssertEqual(str, "")

        // basic format
        format = "|$T| $L: $M"
        str = obj.formatMessage(format, level: .Verbose, msg: "Hello", thread: "main",
            file: "/path/to/ViewController.swift", function: "testFunction()", line: 50)
        XCTAssertEqual(str, "|main| VERBOSE: Hello")

        // format with date and color
        let obj2 = BaseDestination()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStr = formatter.string(from: NSDate() as Date)

        obj2.levelColor.Verbose = "?"
        obj2.escape = ">"
        obj2.reset = "<"

        format = "[$Dyyyy-MM-dd HH:mm:ss$d] |$T| $N.$F:$l $C$L$c: $M"
        str = obj2.formatMessage(format, level: .Verbose, msg: "Hello", thread: "main",
                                 file: "/path/to/ViewController.swift", function: "testFunction()", line: 50)
        XCTAssertEqual(str, "[\(dateStr)] |main| ViewController.testFunction():50 >?VERBOSE<: Hello")

        /*
         WORKING !!!

        // format with JSON message
        // test was deactivated because it seems impossible to test for \\" in Swift 3?!
        format = "$L: $m"
        str = obj.formatMessage(format, level: .Verbose, msg: "Hello \"world\" yeah", thread: "main",
                                file: "/path/to/ViewController.swift", function: "testFunction()", line: 50)
        print(str)

        // JSON format, just message needs to be encoded -> IS WORKING!
        format = "{\"level\": \"$L\", \"message\": \"$m\", \"line\":$l}"
        str = obj.formatMessage(format, level: .Verbose, msg: "Hello \"world\" yeah", thread: "main",
                                file: "/path/to/ViewController.swift", function: "testFunction()", line: 50)
        print(str)
        */
    }

    func testLevelWord() {
        let obj = BaseDestination()
        var str = ""

        str = obj.levelWord(SwiftyBeaver.Level.Verbose)
        XCTAssertNotNil(str, "VERBOSE")
        str = obj.levelWord(SwiftyBeaver.Level.Debug)
        XCTAssertNotNil(str, "DEBUG")
        str = obj.levelWord(SwiftyBeaver.Level.Info)
        XCTAssertNotNil(str, "INFO")
        str = obj.levelWord(SwiftyBeaver.Level.Warning)
        XCTAssertNotNil(str, "WARNING")
        str = obj.levelWord(SwiftyBeaver.Level.Error)
        XCTAssertNotNil(str, "ERROR")

        // custom level strings
        obj.levelString.Verbose = "Who cares"
        obj.levelString.Debug = "Look"
        obj.levelString.Info = "Interesting"
        obj.levelString.Warning = "Oh oh"
        obj.levelString.Error = "OMG!!!"

        str = obj.levelWord(SwiftyBeaver.Level.Verbose)
        XCTAssertNotNil(str, "Who cares")
        str = obj.levelWord(SwiftyBeaver.Level.Debug)
        XCTAssertNotNil(str, "Look")
        str = obj.levelWord(SwiftyBeaver.Level.Info)
        XCTAssertNotNil(str, "Interesting")
        str = obj.levelWord(SwiftyBeaver.Level.Warning)
        XCTAssertNotNil(str, "Oh oh")
        str = obj.levelWord(SwiftyBeaver.Level.Error)
        XCTAssertNotNil(str, "OMG!!!")
    }

    func testColorForLevel() {
        let obj = BaseDestination()
        var str = ""

        // empty on default
        str = obj.colorForLevel(SwiftyBeaver.Level.Verbose)
        XCTAssertNotNil(str, "")
        str = obj.colorForLevel(SwiftyBeaver.Level.Debug)
        XCTAssertNotNil(str, "")
        str = obj.colorForLevel(SwiftyBeaver.Level.Info)
        XCTAssertNotNil(str, "")
        str = obj.colorForLevel(SwiftyBeaver.Level.Warning)
        XCTAssertNotNil(str, "")
        str = obj.colorForLevel(SwiftyBeaver.Level.Error)
        XCTAssertNotNil(str, "")

        // custom level color strings
        obj.levelString.Verbose = "silver"
        obj.levelString.Debug = "green"
        obj.levelString.Info = "blue"
        obj.levelString.Warning = "yellow"
        obj.levelString.Error = "red"

        str = obj.colorForLevel(SwiftyBeaver.Level.Verbose)
        XCTAssertNotNil(str, "silver")
        str = obj.colorForLevel(SwiftyBeaver.Level.Debug)
        XCTAssertNotNil(str, "green")
        str = obj.colorForLevel(SwiftyBeaver.Level.Info)
        XCTAssertNotNil(str, "blue")
        str = obj.colorForLevel(SwiftyBeaver.Level.Warning)
        XCTAssertNotNil(str, "yellow")
        str = obj.colorForLevel(SwiftyBeaver.Level.Error)
        XCTAssertNotNil(str, "red")
    }

    func testFileNameOfFile() {
        let obj = BaseDestination()
        var str = ""

        str = obj.fileNameOfFile("")
        XCTAssertEqual(str, "")
        str = obj.fileNameOfFile("foo.bar")
        XCTAssertEqual(str, "foo.bar")
        str = obj.fileNameOfFile("path/to/ViewController.swift")
        XCTAssertEqual(str, "ViewController.swift")
    }

    func testFileNameOfFileWithoutSuffix() {
        let obj = BaseDestination()
        var str = ""

        str = obj.fileNameWithoutSuffix("")
        XCTAssertEqual(str, "")
        str = obj.fileNameWithoutSuffix("/")
        XCTAssertEqual(str, "")
        str = obj.fileNameWithoutSuffix("foo")
        XCTAssertEqual(str, "foo")
        str = obj.fileNameWithoutSuffix("foo.bar")
        XCTAssertEqual(str, "foo")
        str = obj.fileNameWithoutSuffix("path/to/ViewController.swift")
        XCTAssertEqual(str, "ViewController")
    }

    func testFormatDate() {
        // empty format
        var str = BaseDestination().formatDate("")
        XCTAssertEqual(str, "")
        // no time format
        str = BaseDestination().formatDate("--")
        XCTAssertGreaterThanOrEqual(str, "--")
        // HH:mm:ss
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let dateStr = formatter.string(from: NSDate() as Date)
        str = BaseDestination().formatDate(formatter.dateFormat)
        XCTAssertEqual(str, dateStr)
    }


    ////////////////////////////////
    // MARK: Filters
    ////////////////////////////////


    func test_init_noMinLevelExplicitelySet_createsOneMatchingLevelFilter() {
        let destination = BaseDestination()
        XCTAssertEqual(destination.filters.count, 1)
    }

    func test_init_newMinLevelExplicitelySet_createsOneMatchingLevelFilter() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.Info
        XCTAssertEqual(destination.filters.count, 1)
    }

    func test_init_newMinLevelExplicitelySetAndPasses_True() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.Info
        XCTAssertTrue(destination.shouldLevelBeLogged(level: SwiftyBeaver.Level.Info, file: "", function: ""))
    }

    func test_init_newMinLevelExplicitelySetAndDoesNotPass_False() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.Info
        XCTAssertFalse(destination.shouldLevelBeLogged(level: SwiftyBeaver.Level.Verbose, file: "", function: ""))
    }

    func test_shouldLevelBeLogged_hasLevelFilterAndOneEqualsPathFilterAndPasses_True() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.Info
        destination.addFilter(filter: Filters.Path.equals(strings: "/world/beaver.swift",
                                                          caseSensitive: true, required: true))
        XCTAssertTrue(destination.shouldLevelBeLogged(level: SwiftyBeaver.Level.Warning,
                                                      file: "/world/beaver.swift", function: "initialize"))
    }

    func test_shouldLevelBeLogged_hasLevelFilterAndOneEqualsPathFilterAndDoesNotPass_False() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.Info
        destination.addFilter(filter: Filters.Path.equals(strings: "/world/beaver.swift",
                                                          caseSensitive: true, required: true))
        XCTAssertFalse(destination.shouldLevelBeLogged(level: SwiftyBeaver.Level.Warning,
                                                       file: "/hello/foo.swift", function: "initialize"))
    }

    func test_shouldLevelBeLogged_hasLevelFilterAndTwoRequiredPathFiltersAndPasses_True() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.Info
        destination.addFilter(filter: Filters.Path.startsWith(prefixes: "/world",
                                                              caseSensitive: true, required: true))
        destination.addFilter(filter: Filters.Path.endsWith(suffixes: "beaver.swift",
                                                            caseSensitive: true, required: true))
        XCTAssertTrue(destination.shouldLevelBeLogged(level: SwiftyBeaver.Level.Warning,
                                                      file: "/world/beaver.swift", function: "initialize"))
    }

    func test_shouldLevelBeLogged_hasLevelFilterAndTwoRequiredPathFiltersAndDoesNotPass_False() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.Info
        destination.addFilter(filter: Filters.Path.startsWith(prefixes: "/world", caseSensitive: true, required: true))
        destination.addFilter(filter: Filters.Path.endsWith(suffixes: "foo.swift", caseSensitive: true, required: true))
        XCTAssertFalse(destination.shouldLevelBeLogged(level: SwiftyBeaver.Level.Warning,
                                                       file: "/hello/foo.swift", function: "initialize"))
    }

    func test_shouldLevelBeLogged_hasLevelFilterARequiredPathFilterAndTwoRequiredMessageFiltersAndPasses_True() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.Info
        destination.addFilter(filter: Filters.Path.startsWith(prefixes: "/world", caseSensitive: true, required: true))
        destination.addFilter(filter: Filters.Message.startsWith(prefixes: "SQL:", caseSensitive: true, required: true))
        destination.addFilter(filter: Filters.Message.contains(strings: "insert", caseSensitive: false, required: true))
        XCTAssertTrue(destination.shouldLevelBeLogged(level: SwiftyBeaver.Level.Warning,
                                                      file: "/world/beaver.swift", function: "executeSQLStatement",
                                                      message: "SQL: INSERT INTO table (c1, c2) VALUES (1, 2)"))
    }

    func test_shouldLevelBeLogged_hasLevelFilterARequiredPathFilterAnd2RequiredMessageFiltersAndDoesNotPass_False() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.Info
        destination.addFilter(filter: Filters.Path.startsWith(prefixes: "/world", caseSensitive: true, required: true))
        destination.addFilter(filter: Filters.Message.startsWith(prefixes: "SQL:", caseSensitive: true, required: true))
        destination.addFilter(filter: Filters.Message.contains(strings: "insert", caseSensitive: false, required: true))
        XCTAssertFalse(destination.shouldLevelBeLogged(level: SwiftyBeaver.Level.Warning,
                                                       file: "/world/beaver.swift", function: "executeSQLStatement",
                                                       message: "SQL: DELETE FROM table WHERE c1 = 1"))
    }

    func test_shouldLevelBeLogged_hasLevelFilterCombinationOfAllOtherFiltersAndPasses_True() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.Info
        destination.addFilter(filter: Filters.Path.startsWith(prefixes: "/world", caseSensitive: true, required: true))
        destination.addFilter(filter: Filters.Path.endsWith(suffixes: "/beaver.swift",
                                                            caseSensitive: true, required: true))
        destination.addFilter(filter: Filters.Function.equals(strings: "executeSQLStatement", required: true))
        destination.addFilter(filter: Filters.Message.startsWith(prefixes: "SQL:", caseSensitive: true, required: true))
        destination.addFilter(filter: Filters.Message.contains(strings: "insert", "update", "delete", required: true))
        XCTAssertTrue(destination.shouldLevelBeLogged(level: SwiftyBeaver.Level.Warning,
                                                      file: "/world/beaver.swift", function: "executeSQLStatement",
                                                      message: "SQL: INSERT INTO table (c1, c2) VALUES (1, 2)"))
    }

    func test_shouldLevelBeLogged_hasLevelFilterCombinationOfAllOtherFiltersAndDoesNotPass_False() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.Info
        destination.addFilter(filter: Filters.Path.startsWith(prefixes: "/world", caseSensitive: true, required: true))
        destination.addFilter(filter: Filters.Path.endsWith(suffixes: "/beaver.swift",
                                                            caseSensitive: true, required: true))
        destination.addFilter(filter: Filters.Function.equals(strings: "executeSQLStatement", required: true))
        destination.addFilter(filter: Filters.Message.startsWith(prefixes: "SQL:", caseSensitive: true, required: true))
        destination.addFilter(filter: Filters.Message.contains(strings: "insert", "update", "delete", required: true))
        XCTAssertFalse(destination.shouldLevelBeLogged(level: SwiftyBeaver.Level.Warning,
                                                       file: "/world/beaver.swift", function: "executeSQLStatement",
                                                       message: "SQL: CREATE TABLE sample (c1 INTEGER, c2 VARCHAR)"))
    }

    func test_shouldLevelBeLogged_hasLevelFilterCombinationOfOtherFiltersIncludingNonRequiredAndPasses_True() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.Info
        destination.addFilter(filter: Filters.Path.startsWith(prefixes: "/world", caseSensitive: true, required: true))
        destination.addFilter(filter: Filters.Path.endsWith(suffixes: "/beaver.swift",
                                                            caseSensitive: true, required: true))
        destination.addFilter(filter: Filters.Function.equals(strings: "executeSQLStatement", required: true))
        destination.addFilter(filter: Filters.Message.startsWith(prefixes: "SQL:", caseSensitive: true, required: true))
        destination.addFilter(filter: Filters.Message.contains(strings: "insert"))
        destination.addFilter(filter: Filters.Message.contains(strings: "update"))
        destination.addFilter(filter: Filters.Message.contains(strings: "delete"))
        XCTAssertTrue(destination.shouldLevelBeLogged(level: SwiftyBeaver.Level.Warning,
                                                      file: "/world/beaver.swift", function: "executeSQLStatement",
                                                      message: "SQL: INSERT INTO table (c1, c2) VALUES (1, 2)"))
    }

    func test_shouldLevelBeLogged_hasLevelFilterCombinationOfOtherFiltersIncludingNonRequiredAndDoesNotPass_False() {
        let destination = BaseDestination()
        destination.minLevel = SwiftyBeaver.Level.Info
        destination.addFilter(filter: Filters.Path.startsWith(prefixes: "/world", caseSensitive: true, required: true))
        destination.addFilter(filter: Filters.Path.endsWith(suffixes: "/beaver.swift",
                                                            caseSensitive: true, required: true))
        destination.addFilter(filter: Filters.Function.equals(strings: "executeSQLStatement", required: true))
        destination.addFilter(filter: Filters.Message.startsWith(prefixes: "SQL:", caseSensitive: true, required: true))
        destination.addFilter(filter: Filters.Message.contains(strings: "insert", caseSensitive: true))
        destination.addFilter(filter: Filters.Message.contains(strings: "update"))
        destination.addFilter(filter: Filters.Message.contains(strings: "delete"))
        XCTAssertFalse(destination.shouldLevelBeLogged(level: SwiftyBeaver.Level.Warning,
                                                       file: "/world/beaver.swift", function: "executeSQLStatement",
                                                       message: "SQL: INSERT INTO table (c1, c2) VALUES (1, 2)"))
    }

}
