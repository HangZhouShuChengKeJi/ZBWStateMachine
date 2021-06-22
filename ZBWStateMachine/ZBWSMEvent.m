//
//  ZBWSMEvent.m
//  ZBWStateMachine
//
//  Created by Bowen on 16/10/14.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import "ZBWSMEvent.h"

@interface ZBWSMEvent ()

@property (nonatomic, assign) NSInteger     uniqueId;
@property (nonatomic) NSArray                       *fromStates;
@property (nonatomic) ZBWSMState                    *toState;

@end

@implementation ZBWSMEvent

+ (instancetype)eventWithName:(NSString *)name
                     uniqueId:(NSInteger)uniqueId
                   fromStates:(NSArray *)fromStates
                      toState:(ZBWSMState *)toState
{
    ZBWSMEvent *event = [[ZBWSMEvent alloc] init];
    event.uniqueId = uniqueId;
    event.name = name;
    event.fromStates = fromStates;
    event.toState = toState;
    
    return event;
}

- (void)setFromStates:(NSArray *)fromStates
{
    if (fromStates.count > 0) {
        [fromStates enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSAssert([obj isKindOfClass:[ZBWSMState class]], @"【状态机】fromStates必须是ZBWSMState数组！！！");
        }];
    }
    
    _fromStates = fromStates;
}

- (void)setToState:(ZBWSMState *)toState
{
    _toState = toState;
    
    NSAssert(toState && [toState isKindOfClass:[ZBWSMState class]], @"【状态机】toState必须是ZBWSMState！！！");
}

@end
