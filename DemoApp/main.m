//
//  main.m
//  TypeCheckedCollectionAccess
//
//  Created by Benedict Cohen on 20/10/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BCLContinuations.h"



void demo(void) {

    NSError *continuationsError =
    [BCLContinuations untilError:

     nil];

    NSLog(@"error: %@", continuationsError);
}



int main(int argc, const char * argv[]) {
    @autoreleasepool {
        demo();
    }
    return 0;
}
