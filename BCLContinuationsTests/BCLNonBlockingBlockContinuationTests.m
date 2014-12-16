//
//  BCLNonBlockingBlockContinuationTests.m
//  BCLContinuations
//
//  Created by Benedict Cohen on 29/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "BCLContinuations.h"



@interface BCLNonBlockingBlockContinuationTests : XCTestCase

@end



@implementation BCLNonBlockingBlockContinuationTests

-(void)testValidConstruction
{
    //Given
    NSString *name = @"test continuation";
    BCLNonBlockingBlockContinuation *continuation = BCLNonBlockingContinuationWithBlock(name, ^(BCLContinuationCompletionHandler handler) {
        handler(YES, nil);
    });

    //When

    //Then
    XCTAssertNotNil(continuation, @"Construction failed.");
    XCTAssertEqualObjects(name, continuation.name, "Construction failed.");
    XCTAssertNotNil(continuation.block, "Construction failed.");
}



-(void)testInvalidConstruction
{
    //Given
    //When
    //Then
#pragma GCC diagnostic ignored "-Wall"
    XCTAssertThrows(BCLNonBlockingContinuationWithBlock(NULL), @"Construction failed.");
#pragma GCC diagnostic pop
}



-(void)testInvocationWithSuccessfulBlock
{
    //Given
    NSString *name = @"test continuation";
    BCLBlockContinuation *continuation = BCLNonBlockingContinuationWithBlock(^(BCLContinuationCompletionHandler handler) {
        handler(YES, nil);
    });

    //When
    __block id actualResult = nil;
    __block id actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    id expectedResult = @YES;
    XCTAssertEqualObjects(expectedResult, actualResult);
    id expectedError = nil;
    XCTAssertEqualObjects(expectedError, actualError);
}



-(void)testInvocationWithSuccessfulBlockWithIncorrectOutError
{
    //Given
    NSString *name = @"test continuation";
    NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:nil];
    BCLBlockContinuation *continuation = BCLNonBlockingContinuationWithBlock(^(BCLContinuationCompletionHandler handler) {
        handler(YES, error);
    });

    //When
    __block id actualResult = nil;
    __block id actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    id expectedResult = @YES;
    XCTAssertEqualObjects(expectedResult, actualResult);
    id expectedError = nil;
    XCTAssertEqualObjects(expectedError, actualError);
}



-(void)testInvocationWithFailedBlock
{
    //Given
    NSString *name = @"test continuation";
    NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:nil];
    BCLBlockContinuation *continuation = BCLNonBlockingContinuationWithBlock(^(BCLContinuationCompletionHandler handler) {
        handler(NO, error);
    });

    //When
    __block id actualResult = nil;
    __block id actualError = nil;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualError = error;
    }];

    //Then
    id expectedResult = @NO;
    XCTAssertEqualObjects(expectedResult, actualResult);
    id expectedError = error;
    XCTAssertEqualObjects(expectedError, actualError);
}



-(void)testInvocationWithFailedBlockWithIncorrectOutError
{
    //Given
    NSString *name = @"test continuation";
    NSError *error = [NSError errorWithDomain:@"" code:0 userInfo:nil];
    BCLBlockContinuation *continuation = BCLNonBlockingContinuationWithBlock(^(BCLContinuationCompletionHandler handler) {
        handler(NO, nil);
    });

    //When
    __block id actualResult = nil;
    __block NSInteger actualErrorCode = 0;
    [continuation executeWithCompletionHandler:^(BOOL didSucceed, NSError *error) {
        actualResult = @(didSucceed);
        actualErrorCode = error.code;
    }];

    //Then
    id expectedResult = @YES;
    XCTAssertEqualObjects(expectedResult, actualResult);
    NSInteger expectedErrorCode = BCLUnknownError;
    XCTAssertEqual(expectedErrorCode, actualErrorCode);
}

@end
