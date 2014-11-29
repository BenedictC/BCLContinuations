//
//  BCLBlockContinuation.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 27/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCLBlockContinuation.h"



@implementation BCLBlockContinuation

-(instancetype)init
{
    return [self initWithBlock:NULL];
}



-(instancetype)initWithName:(NSString *)name block:(BOOL(^)(NSError **outError))block
{
    if (block == NULL) {
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"'block' must not be NULL" userInfo:nil] raise];
        return nil;
    }

    self = [super init];
    if (self == nil) return nil;

    _block = block;
    _name = [name copy];

    return self;
}



-(instancetype)initWithBlock:(BOOL(^)(NSError **outError))block
{
    return [self initWithName:nil block:block];
}



-(void)executeWithCompletionHandler:(void(^)(BOOL didSucceed, NSError *error))completionHandler
{
    NSError *error = nil;
    BOOL didSucceed = self.block(&error);

    completionHandler(didSucceed, error);
}

@end



id<BCLContinuation> __attribute__((overloadable)) BCLContinuationWithBlock(NSString *name, BOOL(^block)(NSError **outError)) {
    return [[BCLBlockContinuation alloc] initWithName:name block:block];
}



id<BCLContinuation> __attribute__((overloadable)) BCLContinuationWithBlock(BOOL(^block)(NSError **outError)) {

    return [[BCLBlockContinuation alloc] initWithBlock:block];
}
