//
//  ViewController.m
//  ThreadManagement
//
//  Created by QSP on 2018/7/16.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSThread创建线程
    //类方法，选择器的方式生成线程
    [NSThread detachNewThreadSelector:@selector(myThreadMainMethod:) toTarget:self withObject:nil];
    //类方法，block的方式生成线程
    [NSThread detachNewThreadWithBlock:^{
        NSLog(@"\n++++%s, Thread:%@", __FUNCTION__, [NSThread currentThread]);
    }];
    
    //初始化NSThread对象，选择器的方式生成线程
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(myThreadMainMethod:) object:nil];
    [thread start];
    //初始化NSThread对象，block的方式生成线程
    NSThread *otherThread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"\n++++%s, Thread:%@", __FUNCTION__, [NSThread currentThread]);
    }];
    [otherThread start];
    
    [self performSelector:@selector(myThreadMainMethod:) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];
//    [self performSelector:@selector(myThreadMainMethod:) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO modes:nil];
}

- (void)myThreadMainMethod:(id)object {
    NSLog(@"\n----%s, Thread:%@", __FUNCTION__, [NSThread currentThread]);
}


@end
