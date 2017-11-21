//
//  TaskProtocol.h
//  BTTask
//
//  Created by Brooks on 2017/11/21.
//  Copyright © 2017年 https://github.com/BrooksWon All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TaskProtocol <NSObject>

@required
- (BOOL)needMainThread;

@end
