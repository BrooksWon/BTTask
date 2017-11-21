//
//  BTTask.m
//  BTTask
//
//  Created by Brooks on 2017/11/21.
//  Copyright © 2017年 https://github.com/BrooksWon All rights reserved.
//

#import "BTTask.h"

typedef NS_ENUM(NSInteger, BTTaskState) {
    BTTaskStateCreate,
    BTTaskStateReady = 1,
    BTTaskStateLoading,
    BTTaskStateSuccessed,
    BTTaskStateFailure,
    BTTaskStateCanceled,
};

static inline BOOL BTTaskStateTransitionIsValid(BTTaskState fromState, BTTaskState toState) {
    
    switch (fromState) {
        case BTTaskStateReady:
        {
            switch (toState) {
                case BTTaskStateLoading:
                case BTTaskStateSuccessed:
                case BTTaskStateFailure:
                case BTTaskStateCanceled:
                    return YES;
                    break;
                default:
                    return NO;
                    break;
            }
            break;
        }
        case BTTaskStateLoading:
        {
            switch (toState) {
                case BTTaskStateSuccessed:
                case BTTaskStateFailure:
                case BTTaskStateCanceled:
                    return YES;
                    break;
                default:
                    return NO;
                    break;
            }
        }
        case (BTTaskState)0:
        {
            if (toState == BTTaskStateReady) {
                return YES;
            } else {
                return NO;
            }
        }
            
        default:
            return NO;
            break;
    }
}

@interface BTTask ()

@property (nonatomic, assign) BTTaskState state;
@property (nonatomic, strong, readonly) NSRecursiveLock *lock;
@property (nonatomic, copy) NSError *(^mainBlock)(BTTask *task);

@end

@implementation BTTask

@synthesize lock = _lock;

#pragma mark - init

+ (instancetype)taskWithBlock:(NSError *(^)(BTTask *))block
{
    BTTask *task = [[BTTask alloc] init];
    [task setMainBlock:block];
    return task;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.state = BTTaskStateReady;
    }
    return self;
}

- (NSRecursiveLock *)lock {
    if (!_lock) {
        _lock = [[NSRecursiveLock alloc] init];
    }
    return _lock;
}

#pragma mark - operation lifetime

- (void)start
{
    [self.lock lock];
    if ([self isReady]) {
        
        self.state = BTTaskStateLoading;
        NSLog(@"%@ begin", NSStringFromClass(self.class));
        [self.lock unlock];
        
        [self executeTask];
    } else {
        [self.lock unlock];
    }
}

#pragma mark - state

- (void)executeTask
{
    if (self.mainBlock) {
        NSError *error = self.mainBlock(self);
        [self finishWithError:error];
    } else {
        @throw [NSException exceptionWithName:@"BTTaskException" reason:@"need override" userInfo:nil];
    }
}

- (void)finishWithError:(NSError *)error
{
    [self.lock lock];
    if (![self isFinished]) {
        
        NSLog(@"%@ finish", NSStringFromClass(self.class));
        if (error) {
            self.error = error;
            self.state = BTTaskStateFailure;
        } else {
            self.state = BTTaskStateSuccessed;
        }
        
    }
    [self.lock unlock];
}

- (void)cancel
{
    [self.lock lock];
    
    if (![self isFinished])
    {
        self.state = BTTaskStateCanceled;
        [super cancel];
        NSLog(@"%@ cancel", NSStringFromClass(self.class));
    }
    
    [self.lock unlock];
}

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isReady
{
    return self.state == BTTaskStateReady && [super isReady];
}

- (BOOL)isFinished
{
    return self.state == BTTaskStateSuccessed || self.state == BTTaskStateFailure || self.state == BTTaskStateCanceled;
}

- (BOOL)isExecuting
{
    return self.state == BTTaskStateLoading;
}

- (BOOL)isCancelled
{
    return self.state == BTTaskStateCanceled;
}

- (void)setState:(BTTaskState)state
{
    [self.lock lock];
    if (!BTTaskStateTransitionIsValid(_state, state)) {
        [self.lock unlock];
        return;
    }
    
    switch (state) {
        case BTTaskStateCanceled:
        {
            [self willChangeValueForKey:@"isExecuting"];
            [self willChangeValueForKey:@"isFinished"];
            [self willChangeValueForKey:@"isCancelled"];
            _state = state;
            [self didChangeValueForKey:@"isExecuting"];
            [self didChangeValueForKey:@"isFinished"];
            [self didChangeValueForKey:@"isCancelled"];
            break;
        }
        case BTTaskStateLoading:
        {
            [self willChangeValueForKey:@"isExecuting"];
            _state = state;
            [self didChangeValueForKey:@"isExecuting"];
            break;
        }
        case BTTaskStateSuccessed:
        case BTTaskStateFailure:
        {
            [self willChangeValueForKey:@"isFinished"];
            [self willChangeValueForKey:@"isExecuting"];
            _state = state;
            [self didChangeValueForKey:@"isFinished"];
            [self didChangeValueForKey:@"isExecuting"];
            break;
        }
        case BTTaskStateReady:
        {
            [self willChangeValueForKey:@"isReady"];
            _state = state;
            [self didChangeValueForKey:@"isReady"];
            break;
        }
        default:
        {
            _state = state;
            break;
        }
    }
    
    [self.lock unlock];
}

@end



