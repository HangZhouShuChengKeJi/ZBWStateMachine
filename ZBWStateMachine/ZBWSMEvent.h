//
//  ZBWSMEvent.h
//  ZBWStateMachine
//
//  Created by Bowen on 16/10/14.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZBWSMState.h"

/**
 状态机状态转换的事件
 */
@interface ZBWSMEvent : NSObject

@property (nonatomic, copy) NSString        *name;
@property (nonatomic, assign) NSInteger     uniqueId;
@property (nonatomic) NSArray               *fromStates;
@property (nonatomic) ZBWSMState             *toState;


+ (instancetype)eventWithName:(NSString *)name
                     uniqueId:(NSInteger)uniqueId
                   fromStates:(NSArray *)fromStates
                      toState:(ZBWSMState *)toState;

@end
