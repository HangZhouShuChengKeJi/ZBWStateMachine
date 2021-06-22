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

// 名称
@property (nonatomic, copy) NSString                *name;
// 唯一id，一个状态机中的事件，不能重复
@property (nonatomic, assign, readonly) NSInteger   uniqueId;
// 哪些状态可以接收 该事件
@property (nonatomic, readonly) NSArray             *fromStates;
// 接收到该事件后，转变到toState状态
@property (nonatomic, readonly) ZBWSMState          *toState;


+ (instancetype)eventWithName:(NSString *)name
                     uniqueId:(NSInteger)uniqueId
                   fromStates:(NSArray *)fromStates
                      toState:(ZBWSMState *)toState;

@end
