//
//  BCLNonBlockingBlockContinuation.h
//  BCJSONMapper
//
//  Created by Benedict Cohen on 25/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLContinuationProtocol.h"


/**
 <#Description#>

 @param BOOL    <#BOOL description#>
 @param NSError <#NSError description#>
 */
typedef void(^BCLContinuationCompletionHandler)(BOOL, NSError *);


/**
 BCLNonBlockingBlockContinuation conforms to BCLContinuation and is used to create asynchronous continuations.
 */
@interface BCLNonBlockingBlockContinuation : NSObject <BCLContinuation>
/**
 Intialize an instance using the supplied block.

 @param block the contination block.

 @return An initalized continuation.
 */
-(instancetype)initWithBlock:(void(^)(BCLContinuationCompletionHandler completionHandler))block;

-(instancetype)initWithName:(NSString *)name block:(void(^)(BCLContinuationCompletionHandler completionHandler))block;
@property(nonatomic, readonly) NSString *name;
@property(nonatomic, readonly, copy) void(^block)(BCLContinuationCompletionHandler completionHandler);

@end



id<BCLContinuation> __attribute__((overloadable)) BCLNonBlockingContinuationWithBlock(NSString *name, void(^continuationBlock)(BCLContinuationCompletionHandler completionHandler)) __attribute__((warn_unused_result));

id<BCLContinuation> __attribute__((overloadable)) BCLNonBlockingContinuationWithBlock(void(^continuationBlock)(BCLContinuationCompletionHandler completionHandler)) __attribute__((warn_unused_result));
