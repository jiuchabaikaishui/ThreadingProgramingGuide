//
//  AppDelegate.h
//  RunLoops
//
//  Created by QSP on 2018/7/16.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RunLoopSource.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)registerSource:(RunLoopContext *)context;
- (void)removeSource:(RunLoopContext *)context;

@end

