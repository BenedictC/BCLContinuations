//
//  BCLNonBlockingBlockContinuation.m
//  BCJSONMapper
//
//  Created by Benedict Cohen on 25/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLNonBlockingBlockContinuation.h"



@implementation BCLNonBlockingBlockContinuation

-(instancetype)init
{
    return [self initWithName:nil block:NULL];
}



-(instancetype)initWithBlock:(void(^)(BCLContinuationCompletionHandler handler))block
{
    return [self initWithName:nil block:block];
}



-(instancetype)initWithName:(NSString *)name block:(void(^)(BCLContinuationCompletionHandler handler))block
{
    if (block == NULL) {
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"'block' must not be NULL" userInfo:nil] raise];
        return nil;
    }

    self = [super init];
    if (self == nil) return nil;

    _block = block;

    return self;
}



-(void)executeWithCompletionHandler:(void(^)(BOOL didSucceed, NSError *error))completionHandler
{
    self.block(completionHandler);
}

@end



id<BCLContinuation> __attribute__((overloadable)) BCLNonBlockingContinuationWithBlock(NSString *name, void(^continuationBlock)(BCLContinuationCompletionHandler handler)) {
    return [[BCLNonBlockingBlockContinuation alloc] initWithName:name block:continuationBlock];
}



id<BCLContinuation> __attribute__((overloadable)) BCLNonBlockingContinuationWithBlock(void(^continuationBlock)(BCLContinuationCompletionHandler handler)) {
    return [[BCLNonBlockingBlockContinuation alloc] initWithName:nil block:continuationBlock];
}
