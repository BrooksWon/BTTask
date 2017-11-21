//
//  Task4.m
//  BTTask
//
//  Created by Brooks on 2017/11/21.
//  Copyright © 2017年 https://github.com/BrooksWon. All rights reserved.
//

#import "Task4.h"

@implementation Task4

- (void)executeTask
{
    NSLog(@"Thread %@", [NSThread currentThread]);
    [self finishWithError:nil];
}

- (BOOL)needMainThread
{
    return NO;
}


@end
