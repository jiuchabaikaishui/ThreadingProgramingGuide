//
//  RunLoopSource.m
//  ThreadingPrograming
//
//  Created by QSP on 2018/7/31.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import "RunLoopSource.h"
#import <UIKit/UIKit.h>

@interface RunLoopSource ()

@property (assign, nonatomic) CFRunLoopRef rl;

@end

@implementation RunLoopSource


void RunLoopSourceScheduleRoutine(void *info, CFRunLoopRef rf, CFStringRef mode) {
    RunLoopSource *source = (__bridge RunLoopSource *)info;
    RunLoopContext *theContext = [[RunLoopContext alloc] initWithSource:source andLoop:rf];
    
    if ([source.delegate respondsToSelector:@selector(registerSource:)]) {
        NSObject *obj = source.delegate;
        [obj performSelectorOnMainThread:@selector(registerSource:) withObject:theContext waitUntilDone:NO];
    }
}
void RunLoopSourcePerformRoutine(void *info) {
    RunLoopSource *source = (__bridge RunLoopSource *)info;
    [source sourceFired];
}
void RunLoopSourceCancelRoutine(void *info, CFRunLoopRef rf, CFStringRef mode) {
    RunLoopSource *source = (__bridge RunLoopSource *)info;
    RunLoopContext *theContext = [[RunLoopContext alloc] initWithSource:source andLoop:rf];
    
    if ([source.delegate respondsToSelector:@selector(removeSource:)]) {
        NSObject *obj = source.delegate;
        [obj performSelectorOnMainThread:@selector(removeSource:) withObject:theContext waitUntilDone:NO];
    }
}


- (instancetype)init {
    if (self = [super init]) {
        CFRunLoopSourceContext context = {0, (__bridge_retained void *)self, NULL, NULL, NULL, NULL, NULL, &RunLoopSourceScheduleRoutine, &RunLoopSourceCancelRoutine, &RunLoopSourcePerformRoutine};
        runLoopSource = CFRunLoopSourceCreate(NULL, 0, &context);
        commands = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)addToCurrentRunLoop {
    CFRunLoopRef rlRef = CFRunLoopGetCurrent();
    [self addToRunLoop:rlRef];
    self.rl = rlRef;
    CFRelease(rlRef);
}
- (void)addToRunLoop:(CFRunLoopRef)rlRef {
    CFRunLoopAddSource(rlRef, runLoopSource, kCFRunLoopDefaultMode);
}
- (void)fireCommandsOnRunLoop:(CFRunLoopRef)runLoop {
    CFRunLoopSourceSignal(runLoopSource);
    CFRunLoopWakeUp(runLoop);
}
- (void)addCommand:(NSInteger)command withData:(id)data {
//    CFRunLoopSource
    [commands addObject:data];
    [self fireCommandsOnRunLoop:self.rl];
}
- (void)sourceFired {
    if (commands.count) {
        NSLog(@"--------------\nthread:%@\ndata:%@", [NSThread currentThread], [commands firstObject]);
        [commands removeObjectAtIndex:0];
    }
}
- (void)invalidate {
    CFRunLoopSourceInvalidate(runLoopSource);
}
- (void)fireAllCommandsOnRunLoop:(CFRunLoopRef)runLoop {
    CFRunLoopSourceGetOrder(runLoopSource);
}

@end

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
