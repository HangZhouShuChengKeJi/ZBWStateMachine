//
//  ZBWStateMachine.h
//  ZBWStateMachine
//
//  Created by Bowen on 16/10/14.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBWSMState.h"
#import "ZBWSMEvent.h"


/**
 一个简单状态机
 管理状态的转变，事件触发
 */
@interface ZBWStateMachine : NSObject

@property (nonatomic, copy) NSString            *name;

// 当前状态
@property (nonatomic, readonly) ZBWSMState       *currentState;

#pragma mark- 构造状态机


/**
 日志开关

 @param isOpen 【YES】打开  【NO】关闭；默认NO
 */
+ (void)openLog:(BOOL)isOpen;

/**
 构造状态机

 @param name      name, 用于调试
 @param states    所有的状态
 @param events    所有的事件
 @param initState 初始状态

 @return 状态机实例
 */
- (instancetype)initWithName:(NSString *)name
                      states:(NSArray *)states
                      events:(NSArray *)events
                   initState:(ZBWSMState *)initState;

/**
 构造状态机
 
 @param name      name, 用于调试
 @param states    所有的状态
 @param events    所有的事件
 @param initState 初始状态
 @param executeQueue 执行队列。如果传空，默认主线程执行。
 
 @return 状态机实例
 */
- (instancetype)initWithName:(NSString *)name
                      states:(NSArray *)states
                      events:(NSArray *)events
                   initState:(ZBWSMState *)initState
               dispatchQueue:(dispatch_queue_t)executeQueue;


#pragma mark 激活状态机
- (void)active;
- (BOOL)isActived;

#pragma mark 触发事件

/**
 触发事件

 @param eventId 事件id
 @param userInfo  传递给下一个状态的数据
 */
- (void)triggerEventId:(NSInteger)eventId userInfo:(id)userInfo;


@end
