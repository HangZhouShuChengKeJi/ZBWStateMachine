//
//  ZBWStateMachine.m
//  ZBWStateMachine
//
//  Created by Bowen on 16/10/14.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import "ZBWStateMachine.h"

#define ZBWSM_CheckStates        1

#if DEBUG
#define ZBWSM_Log(fromatStr, ...) \
    do {\
        if (s_ZBWStateMachine_isOpenLog) {\
            printf(\
            "【状态机 %s】%s\n",\
            [(self.name ?:@"") UTF8String],\
            [[NSString stringWithFormat:fromatStr, ##__VA_ARGS__] UTF8String]\
            );\
        }\
    } while (0);
#else
#define ZBWSM_Log(formatStr, ...)
#endif

static BOOL s_ZBWStateMachine_isOpenLog = NO;

@interface ZBWStateMachine ()

@property (nonatomic, assign) BOOL      isActived;

@property (nonatomic) NSDictionary      *eventsMap;
@property (nonatomic) NSDictionary      *statesMap;
@property (nonatomic) ZBWSMState         *currentState;

@property (nonatomic, strong) dispatch_queue_t  executeQueue;

@end

@implementation ZBWStateMachine

#pragma mark- Public

+ (void)openLog:(BOOL)isOpen
{
    s_ZBWStateMachine_isOpenLog = isOpen;
}

- (instancetype)initWithName:(NSString *)name
                      states:(NSArray *)states
                      events:(NSArray *)events
                   initState:(ZBWSMState *)initState
{
    return [self initWithName:name
                states:states
                events:events
             initState:initState
         dispatchQueue:dispatch_get_main_queue()];
}

- (instancetype)initWithName:(NSString *)name
                      states:(NSArray *)states
                      events:(NSArray *)events
                   initState:(ZBWSMState *)initState
               dispatchQueue:(dispatch_queue_t)executeQueue
{
    if (self = [super init]) {
        self.name = name;
#if ZBWSM_CheckStates
        // 数据校验
        NSSet *statesSet = [NSSet setWithArray:states];
        NSMutableSet *statesInEventsSet = [NSMutableSet set];
#endif
        
        __weak typeof(self) weakSelf = self;
        [states enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZBWSMState *state = obj;
            state.stateMachine = weakSelf;
        }];
        
        NSMutableDictionary *eventsMap = [NSMutableDictionary dictionaryWithCapacity:5];
        [events enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ZBWSMEvent *event = obj;
            NSAssert(event.name, @"【状态机】 event事件的name不能为空！");
            NSAssert(!eventsMap[@(event.uniqueId).description], @"event的uniqueId不能相同");
            eventsMap[@(event.uniqueId).description] = event;
#if ZBWSM_CheckStates
            [statesInEventsSet addObjectsFromArray:event.fromStates];
            [statesInEventsSet addObject:event.toState];
#endif
        }];
        self.eventsMap = [eventsMap copy];
        
        self.currentState = initState;
        
#if ZBWSM_CheckStates
        if (![statesSet isEqualToSet:statesInEventsSet]) {
            ZBWSM_Log(@"初始化数据有误，初始化状态和事件不匹配！！");
        }
#endif
        self.executeQueue = executeQueue;
        if (self.executeQueue == NULL) {
            self.executeQueue = dispatch_get_main_queue();
        }
    }
    return self;
}


- (void)active
{
    @synchronized (self) {
        if (self.isActived) {
            return;
        }
        self.isActived = YES;
        ZBWSM_Log(@"激活状态机");
        __weak ZBWSMState *excuteState = self.currentState;
        dispatch_async(self.executeQueue, ^{
            excuteState.didEnterBlock ? excuteState.didEnterBlock(excuteState, nil) : nil;
            if ([excuteState respondsToSelector:@selector(doSomethingDidEnterState:)]) {
                [excuteState doSomethingDidEnterState:nil];
            }
        });
    }
}

- (void)triggerEventId:(NSInteger)eventId userInfo:(id)userInfo
{
    @synchronized (self) {
        ZBWSMEvent *event = self.eventsMap[@(eventId).description];
        ZBWSM_Log(@"触发Event %@, %@", @(eventId), event.name);
        [self triggerEvent:event userInfo:userInfo];
    }
}

#pragma mark- private

- (void)triggerEvent:(ZBWSMEvent *)event userInfo:(id)userInfo
{
    if (!event) {
        ZBWSM_Log(@"event 为nil，可能忘记添加到event数组中了");
        return;
    }
    
    if (!self.isActived) {
        ZBWSM_Log(@"状态机还未激活！！");
        return;
    }
    
    if (![event.fromStates containsObject:self.currentState]) {
        ZBWSM_Log(@"当前状态:%@ 不能接受事件:%@",self.currentState.name, event.name);
        return;
    }
    
    ZBWSMTransition *transition = [[ZBWSMTransition alloc] init];
    transition.fromState = self.currentState;
    transition.toState = event.toState;
    transition.data = userInfo;
    
    ZBWSM_Log(@"状态转换  %@ -> %@", transition.fromState.name, transition.toState.name);
    
    self.currentState = event.toState;
    __weak ZBWSMState *excuteState = self.currentState;
    dispatch_async(self.executeQueue, ^{
        excuteState.didEnterBlock ? excuteState.didEnterBlock(excuteState, transition) : nil;
        if ([excuteState respondsToSelector:@selector(doSomethingDidEnterState:)]) {
            [excuteState doSomethingDidEnterState:transition];
        }
    });
}

@end
