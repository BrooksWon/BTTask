//
//  Task1.m
//  BTTask
//
//  Created by Brooks on 2017/11/21.
//  Copyright © 2017年 https://github.com/BrooksWon. All rights reserved.
//

#import "Task1.h"

@implementation Task1


- (void)executeTask
{
    sleep(2);
    NSLog(@"Thread %@", [NSThread currentThread]);
    [self finishWithError:nil];
}

- (BOOL)needMainThread
{
    return NO;
}


@end
