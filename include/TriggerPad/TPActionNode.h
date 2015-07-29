//
//  IBActionNode.h
//  thivam
//
//  Created by Ivan Borsa on 23/09/14.
//  Copyright (c) 2014 ivanborsa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TPActionNodeActor.h"
#import "TPActionNodeControllerDelegate.h"
#import "WeakReference.h"

@interface TPActionNode : NSObject

@property (nonatomic, weak) id<TPActionNodeControllerDelegate> delegate;
@property (nonatomic) CGPoint position;
@property (nonatomic, weak) id<TPActionNodeActor> nodeObject;
@property (nonatomic) NSMutableDictionary *connections;
@property (nonatomic) NSMutableDictionary *actions;
@property (nonatomic) int actionHeapSize;
@property (nonatomic) BOOL isPlaceholder;

@property (nonatomic) NSMutableArray *actionIds;

@property (nonatomic) NSMutableDictionary *actionSources;

@property (nonatomic) BOOL isActive;
@property (nonatomic) NSMutableDictionary *connectionDescriptors;

@property (nonatomic) NSMutableDictionary *nodeValues;

-(BOOL)triggerConnectionsWithSource:(CGPoint)source
                    shouldPropagate:(BOOL)shouldPropagate
                      forActionType:(NSString *)actionType
                       withUserInfo:(NSMutableDictionary *)userInfo
                      withNodeReset:(BOOL)reset
                       withActionId:(NSString *)actionId;

-(BOOL)triggerConnectionsWithSource:(CGPoint)source
                    shouldPropagate:(BOOL)shouldPropagate
                      forActionType:(NSString *)actionType
                       withUserInfo:(NSMutableDictionary *)userInfo
                      withNodeReset:(BOOL)reset
                       withActionId:(NSString *)actionId
               andNodeValueModifier:(double)valueModifier
                       forValueType:(NSString *)valueType;

-(BOOL)triggerConnectionsWithSource:(CGPoint)source
                    shouldPropagate:(BOOL)shouldPropagate
                      forActionType:(NSString *)actionType
                       withUserInfo:(NSMutableDictionary *)userInfo
                      withNodeReset:(BOOL)reset
                       withActionId:(NSString *)actionId
               andNodeValueModifier:(double)valueModifier
                       forValueType:(NSString *)valueType
                  inConnectionIndex:(int)connIndex
                 andPassProbability:(double)probability;

-(void)fireOwnActionsForActionType:(NSString *)actionType witUserInfo:(NSMutableDictionary *)userInfo withNodeReset:(BOOL)reset andActionId:(NSString *)actionId;

@end
