//
//  BCLBlockContinuation.h
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 27/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLContinuationProtocol.h"



/**
 BCLBlockContinuation conforms to BCLContinuation and is used to create simple continuations.
 */
@interface BCLBlockContinuation : NSObject <BCLContinuation>
/**
 Intialize an instance using the supplied block.

 @param block the contination block.

 @return An initalized continuation.
 */
-(instancetype)initWithName:(NSString *)name block:(BOOL(^)(NSError **outError))block;
-(instancetype)initWithBlock:(BOOL(^)(NSError **outError))block;
@property(nonatomic, readonly, copy) BOOL(^block)(NSError **outError);
@property(nonatomic, readonly) NSString *name;
@end



id<BCLContinuation> __attribute__((overloadable)) BCLContinuationWithBlock(NSString *name, BOOL(^block)(NSError **outError)) __attribute__((warn_unused_result));
id<BCLContinuation> __attribute__((overloadable)) BCLContinuationWithBlock(BOOL(^block)(NSError **outError)) __attribute__((warn_unused_result));
