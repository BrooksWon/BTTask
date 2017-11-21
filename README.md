# BTTask

## 安装 `BBTask` 步骤：

在你项目的 `Podfile` 中添加以下代码
`pod 'BBTask'`

执行 pod 安装命令
`pod install`

如果无法获取到最新版本的 `BBTask`，请运行以下命令更新本地的 pod 仓库
`pod repo update`

运行完成后，重新执行安装命令
`pod install`

## 用法：

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
    
    
    
## Licence

BBTask is licensed under the [MIT](https://github.com/BrooksWon/BTTask/blob/master/LICENSE) license. Please see the LICENSE file for more information.

## Credits

BBTask was designed and developed by [Brooks](https://github.com/BrooksWon/).

