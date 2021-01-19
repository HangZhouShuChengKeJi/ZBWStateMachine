//
//  ZBWSMState.m
//  ZBWStateMachine
//
//  Created by Bowen on 16/10/14.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import "ZBWSMState.h"

@interface ZBWSMState ()
// 状态名
@property (nonatomic, copy) NSString                *name;

// 进入状态后的操作
@property (nonatomic, copy) ZBWSMStateDidEnterBlock  didEnterBlock;

@end

@implementation ZBWSMState

- (instancetype)initWithName:(nonnull NSString *)name
               didEnterBlock:(nullable ZBWSMStateDidEnterBlock)enterBlock
{
    if (self = [super init]) {
        self.name = name;
        self.didEnterBlock = enterBlock;
    }
    return self;
}

@end
