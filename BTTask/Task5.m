//
//  Task5.m
//  BTTask
//
//  Created by Brooks on 2017/11/21.
//  Copyright © 2017年 https://github.com/BrooksWon. All rights reserved.
//

#import "Task5.h"

@implementation Task5

- (void)executeTask
{
    NSLog(@"=================");
    NSLog(@"Thread %@", [NSThread currentThread]);
    [self finishWithError:nil];
}

- (BOOL)needMainThread
{
    return YES;
}


@end
