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
    return [self initWithBlock:NULL];
}



-(instancetype)initWithBlock:(void(^)(BCLFinishContinuation))block
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



id<BCLContinuation> BCLNonBlockingContinuationWithBlock(void(^block)(BCLFinishContinuation)) {

    return [[BCLNonBlockingBlockContinuation alloc] initWithBlock:block];
}

