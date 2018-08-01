//
//  RunLoopSource.m
//  ThreadingPrograming
//
//  Created by QSP on 2018/7/31.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import "RunLoopSource.h"
#import <UIKit/UIKit.h>

@implementation RunLoopSource

- (instancetype)init {
    if (self = [super init]) {
        CFRunLoopSourceContext context = {0, (__bridge_retained void *)self, NULL, NULL, NULL, NULL, NULL, &RunLoopSourceScheduleRoutine, &RunLoopSourceCancelRoutine, &RunLoopSourcePerformRoutine};
        runLoopSource = CFRunLoopSourceCreate(NULL, 0, &context);
        commands = [NSMutableArray arrayWithCapacity:1];
    }
    
    return self;
}

- (void)addToCurrentRunLoop {
    CFRunLoopRef rf = CFRunLoopGetCurrent();
    CFRunLoopAddSource(rf, runLoopSource, kCFRunLoopDefaultMode);
}
- (void)fireCommandsOnRunLoop:(CFRunLoopRef)runLoop {
    CFRunLoopSourceSignal(runLoopSource);
    CFRunLoopWakeUp(runLoop);
}
- (void)addCommand:(NSInteger)command withData:(id)data {
//    CFRunLoopSource
}
@end

void RunLoopSourceScheduleRoutine(void *info, CFRunLoopRef rf, CFStringRef mode) {
    RunLoopSource *source = (__bridge RunLoopSource *)info;
    id del = [UIApplication sharedApplication].delegate;
    RunLoopContext *theContex = [[RunLoopContext alloc] initWithSource:source andLoop:rf];
    
    [del performSelectorOnMainThread:@selector(registerSource:) withObject:theContex waitUntilDone:NO];
}
void RunLoopSourcePerformRoutine(void *info) {
    RunLoopSource *source = (__bridge RunLoopSource *)info;
    [source sourceFired];
}
void RunLoopSourceCancelRoutine(void *info, CFRunLoopRef rf, CFStringRef mode) {
    RunLoopSource *source = (__bridge RunLoopSource *)info;
    id del = [UIApplication sharedApplication].delegate;
    RunLoopContext *theContext = [[RunLoopContext alloc] initWithSource:source andLoop:rf];
    
    [del performSelectorOnMainThread:@selector(removeResource:) withObject:theContext waitUntilDone:NO];
}

@implementation RunLoopContext
@synthesize source = source;
@synthesize runLoop = runLoop;

- (instancetype)initWithSource:(RunLoopSource *)source andLoop:(CFRunLoopRef)loop {
    if (self = [super init]) {
        source = source;
        runLoop = loop;
    }
    
    return self;
}

@end
