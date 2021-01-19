//
//  ZBWSMTransition.h
//  ZBWStateMachine
//
//  Created by Bowen on 16/10/14.
//  Copyright © 2016年 Bowen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZBWSMState;

@interface ZBWSMTransition : NSObject

@property (nonatomic) ZBWSMState *fromState;
@property (nonatomic) ZBWSMState *toState;
@property (nonatomic) id        data;

@end
