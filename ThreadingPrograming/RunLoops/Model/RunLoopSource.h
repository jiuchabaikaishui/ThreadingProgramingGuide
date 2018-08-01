//
//  RunLoopSource.h
//  ThreadingPrograming
//
//  Created by QSP on 2018/7/31.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RunLoopSource : NSObject
{
    CFRunLoopSourceRef runLoopSource;
    NSMutableArray *commands;
}

- (instancetype)init;
- (void)addToCurrentRunLoop;
- (void)invalidate;

- (void)sourceFired;

- (void)addCommand:(NSInteger)command withData:(id)data;
- (void)fireAllCommandsOnRunLoop:(CFRunLoopRef)runLoop;

@end

void RunLoopSourceScheduleRoutine(void *info, CFRunLoopRef rf, CFStringRef mode);
void RunLoopSourcePerformRoutine(void *info);
void RunLoopSourceCancelRoutine(void *info, CFRunLoopRef rf, CFStringRef mode);


@interface RunLoopContext: NSObject
{
    CFRunLoopRef runLoop;
    RunLoopSource *source;
}
@property (assign, nonatomic, readonly) CFRunLoopRef runLoop;
@property (strong, nonatomic, readonly) RunLoopSource *source;

- (instancetype)initWithSource:(RunLoopSource *)source andLoop:(CFRunLoopRef)loop;

@end
