//
//  BCLContinuationsTests.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 01/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BCLContinuations.h"



@interface BCLContinuationsTests : XCTestCase

@end



@implementation BCLContinuationsTests

-(void)testSynchronousListUntilError
{
    //Given
    NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:nil];
    __block NSInteger actualInvocationCount = 0;
    id<BCLContinuation> continuation = BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        actualInvocationCount++;
        *outError = error;
        return NO;
    });

    //When
    id actualError = [BCLContinuations untilError:
     continuation,
     continuation,
     continuation,
     nil];

    //Then
    id expectedError = error;
    XCTAssertEqualObjects(actualError, expectedError);
    NSInteger expectedInvocationCount = 1;
    XCTAssertEqual(actualInvocationCount, expectedInvocationCount);
}



-(void)testSynchronousListUntilEnd
{
    //Given
    NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:nil];
    __block NSInteger actualInvocationCount = 0;
    id<BCLContinuation> continuation = BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        actualInvocationCount++;
        *outError = error;
        return NO;
    });

    //When
    id actualError = [BCLContinuations untilEnd:
                      continuation,
                      continuation,
                      continuation,
                      nil];

    //Then
    id expectedError = [NSError errorWithDomain:BCLErrorDomain code:BCLMultipleErrorsError userInfo:@{BCLDetailedErrorsKey:@[error, error, error]}];
    XCTAssertEqualObjects(actualError, expectedError);
    NSInteger expectedInvocationCount = 3;
    XCTAssertEqual(actualInvocationCount, expectedInvocationCount);
}



-(void)testSynchronousArrayUntilError
{
    //Given
    NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:nil];
    __block NSInteger actualInvocationCount = 0;
    id<BCLContinuation> continuation = BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        actualInvocationCount++;
        *outError = error;
        return NO;
    });

    //When
    id actualError = [BCLContinuations untilErrorWithContinuations:@[continuation, continuation, continuation]];

    //Then
    id expectedError = error;
    XCTAssertEqualObjects(actualError, expectedError);
    NSInteger expectedInvocationCount = 1;
    XCTAssertEqual(actualInvocationCount, expectedInvocationCount);
}



-(void)testSynchronousArrayUntilEnd
{
    //Given
    NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:nil];
    __block NSInteger actualInvocationCount = 0;
    id<BCLContinuation> continuation = BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        actualInvocationCount++;
        *outError = error;
        return NO;
    });

    //When
    id actualError = [BCLContinuations untilEndWithContinuations:@[continuation, continuation, continuation]];

    //Then
    id expectedError = [NSError errorWithDomain:BCLErrorDomain code:BCLMultipleErrorsError userInfo:@{BCLDetailedErrorsKey:@[error, error, error]}];
    XCTAssertEqualObjects(actualError, expectedError);
    NSInteger expectedInvocationCount = 3;
    XCTAssertEqual(actualInvocationCount, expectedInvocationCount);
}



-(void)testAsynchronousUntilError
{
    //Given
    NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:nil];
    __block NSInteger actualInvocationCount = 0;
    id<BCLContinuation> continuation = BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        actualInvocationCount++;
        *outError = error;
        return NO;
    });

    //When
    __block id actualResult = nil;
    __block id actualError = nil;
    id expectation = [self expectationWithDescription:@"continuation finished"];
    [BCLContinuations untilErrorWithContinuations:@[continuation, continuation, continuation] completionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:1 handler:^(NSError *error) {
        if (error != nil) {
            XCTFail();
        }
    }];

    //Then
    id expectedError = error;
    XCTAssertEqualObjects(actualError, expectedError);
    NSInteger expectedInvocationCount = 1;
    XCTAssertEqual(actualInvocationCount, expectedInvocationCount);
}



-(void)testAsynchronousUntilEnd
{
    //Given
    NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:nil];
    __block NSInteger actualInvocationCount = 0;
    id<BCLContinuation> continuation = BCLContinuationWithBlock(^BOOL(NSError *__autoreleasing *outError) {
        actualInvocationCount++;
        *outError = error;
        return NO;
    });

    //When
    __block id actualResult = nil;
    __block id actualError = nil;
    id expectation = [self expectationWithDescription:@"continuation finished"];
    [BCLContinuations untilEndWithContinuations:@[continuation, continuation, continuation] completionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:1 handler:^(NSError *error) {
        if (error != nil) {
            XCTFail();
        }
    }];

    //Then
    id expectedError = [NSError errorWithDomain:BCLErrorDomain code:BCLMultipleErrorsError userInfo:@{BCLDetailedErrorsKey:@[error, error, error]}];
    XCTAssertEqualObjects(actualError, expectedError);
    NSInteger expectedInvocationCount = 3;
    XCTAssertEqual(actualInvocationCount, expectedInvocationCount);
}

@end
