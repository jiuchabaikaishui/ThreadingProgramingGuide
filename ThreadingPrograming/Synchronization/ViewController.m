//
//  ViewController.m
//  Synchronization
//
//  Created by QSP on 2018/9/17.
//  Copyright © 2018年 Jingbeijinrong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_queue_t queue1 = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"1");
    dispatch_async(queue1, ^{
        NSLog(@"2");
        dispatch_sync(queue1, ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    
    NSLog(@"5");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
