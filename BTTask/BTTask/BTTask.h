//
//  BTTask.h
//  BTTask
//
//  Created by Brooks on 2017/11/21.
//  Copyright © 2017年 https://github.com/BrooksWon All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  task helper class,
 *  1. use taskWithBlock method. you don't need call `finishWithError:`
 *  OR
 *  2. imp `executeTask` method.
 *     - DO NOT override `start` or `main` method.
 *     - you should call `finishWithError:` when the task is done!
 */
@interface BTTask : NSOperation

@property (nonatomic, strong) NSError *error;

/**
 *  create task with block.
 */
+ (instancetype)taskWithBlock:(NSError *(^)(BTTask *task))block;

/**
 *  require override, do the real job in this method, when finish, should call `finishWithError:`
 */
- (void)executeTask;

/**
 *  call this method when task is finished, if error is nil, consider it successed.
 */
- (void)finishWithError:(NSError *)error;

@end

