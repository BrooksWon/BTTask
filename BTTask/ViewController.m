//
//  ViewController.m
//  BTTask
//
//  Created by Brooks on 2017/11/21.
//  Copyright © 2017年 https://github.com/BrooksWon. All rights reserved.
//

#import "ViewController.h"

#import "BTTask.h"
#import "Task1.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 直接使用
    BTTask *task = [BTTask taskWithBlock:^NSError *(BTTask *task) {
        /**
         TODO
         
         */
        
        NSLog(@"BTTask test");
        return nil;
    }];
    
    // 继承，Task1 继承自 BTTask
    Task1 *task1 = [[Task1 alloc] init];
    
    [task1 addDependency:task];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc ] init];
    [queue addOperations:@[task,task1] waitUntilFinished:NO];
    
}


@end
