//
//  ZBWSMState.h
//  ZBWStateMachine
//
//  Created by Bowen on 16/10/14.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBWSMTransition.h"

@class ZBWSMState;
@class ZBWStateMachine;

typedef void (^ZBWSMStateDidEnterBlock)(ZBWSMState * _Nonnull state, ZBWSMTransition * _Nullable transition);



@protocol ZBWSMStateProtocol <NSObject>

@optional
- (void)doSomethingDidEnterState:(ZBWSMTransition *_Nullable)transition;

@end

/**
 状态机状态。
 */
@interface ZBWSMState : NSObject<ZBWSMStateProtocol>
// 状态名
@property (nonatomic, readonly) NSString                * _Nonnull name;
// 标识。默认NSIntegerMax
@property (nonatomic, assign) NSInteger                 flag;
@property (nonatomic, weak) ZBWStateMachine              * _Nullable stateMachine;
@property (nonatomic, readonly) ZBWSMStateDidEnterBlock _Nullable  didEnterBlock;



/**
 状态 构造函数

 @param name         状态名称
 @param enterBlock   进入状态后的操作

 @return 状态实例
 */
- (instancetype _Nonnull )initWithName:(nonnull NSString *)name
                         didEnterBlock:(nullable ZBWSMStateDidEnterBlock)enterBlock;

/**
 状态 构造函数

 @param name         状态名称
 @param flag         标识
 @param enterBlock   进入状态后的操作

 @return 状态实例
 */
- (instancetype _Nonnull )initWithName:(nonnull NSString *)name
                                  flag:(NSInteger)flag
                         didEnterBlock:(nullable ZBWSMStateDidEnterBlock)enterBlock;


@end
