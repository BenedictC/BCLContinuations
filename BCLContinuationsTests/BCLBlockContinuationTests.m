//
//  BCLBlockContinuationTests.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 01/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BCLBlockContinuation.h"
#import "BCLContinuationsClass.h"



@interface BCLBlockContinuationTests : XCTestCase

@end



@implementation BCLBlockContinuationTests

-(void)testValidConstruction
{
    //Given
    NSString *name = @"test continuation";
    BCLBlockContinuation *continuation = BCLContinuationWithBlock(name, ^BOOL(NSError *__autoreleasing *outError) {
        //A block. We can't compare blocks so we can only do a NULL check.
        return YES;
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
    XCTAssertThrows(BCLContinuationWithBlock(NULL), @"Construction failed.");
#pragma GCC diagnostic pop
}


-(void)testInvocationWithSuccessfulBlock
{
    //Given
    NSString *name = @"test continuation";
    BCLBlockContinuation *continuation = BCLContinuationWithBlock(name, ^BOOL(NSError *__autoreleasing *outError) {
        return YES;
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
    BCLBlockContinuation *continuation = BCLContinuationWithBlock(name, ^BOOL(NSError *__autoreleasing *outError) {
        *outError = [NSError errorWithDomain:@"" code:0 userInfo:nil];
        return YES;
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
    BCLBlockContinuation *continuation = BCLContinuationWithBlock(name, ^BOOL(NSError *__autoreleasing *outError) {
        *outError = error;
        return NO;
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
    BCLBlockContinuation *continuation = BCLContinuationWithBlock(name, ^BOOL(NSError *__autoreleasing *outError) {
        *outError = nil;
        return YES;
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
