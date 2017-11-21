//
//  AppDelegate.m
//  BTTask
//
//  Created by Brooks on 2017/11/21.
//  Copyright © 2017年 https://github.com/BrooksWon. All rights reserved.
//

#import "AppDelegate.h"

#import "TaskProtocol.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)testTasksRun {
    NSArray *launchTasks = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"BTLaunchTasks"];
    if (launchTasks.count) {
        
        NSMutableArray *asyncTasks = [[NSMutableArray alloc] init];
        
        NSMutableDictionary *taskMap = [[NSMutableDictionary alloc] init];
        for (NSDictionary *taskInfo in launchTasks) {
            NSAssert([taskInfo isKindOfClass:[NSDictionary class]], @"launchTasks config error");
            
            NSString *className = [taskInfo objectForKey:@"className"];
            Class cls = NSClassFromString(className);
            if ([cls isSubclassOfClass:[NSOperation class]]) {
                
                NSOperation *task = [[cls alloc] init];
                [asyncTasks addObject:task];
                [taskMap setObject:task forKey:className];
                //depedency
                NSArray *dependencyList = [[taskInfo objectForKey:@"dependency"] componentsSeparatedByString:@","];
                if (dependencyList.count) {
                    for (NSString *depedencyClass in dependencyList) {
                        NSOperation *preTask = [taskMap objectForKey:depedencyClass];
                        if (preTask) {
                            [task addDependency:preTask];
                        }
                    }
                }
                
            }
        }
        
        if (asyncTasks.count<=0) return;
        
        NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
        backgroundQueue.maxConcurrentOperationCount = 4;
        
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        
        for (NSOperation *op in asyncTasks) {
                        
            if (![op conformsToProtocol:@protocol(TaskProtocol)]) {
                @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                               reason:[NSString stringWithFormat:@"%@ 模块不符合 TaskProtocol 协议", NSStringFromClass(op.class)]
                                             userInfo:nil];
            }
            
            if (![op respondsToSelector:@selector(needMainThread)]) {
                @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                               reason:[NSString stringWithFormat:@"%@ 模块没实现 TaskProtocol 协议的 %@ 方法", NSStringFromClass(op.class), NSStringFromSelector(@selector(needMainThread))]
                                             userInfo:nil];
            }
            
            
            if ([op performSelector:@selector(needMainThread)]) {
                [mainQueue addOperation:op];
            } else {
                [backgroundQueue addOperation:op];
            }
        }
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self testTasksRun];
    
    //TODO...
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
