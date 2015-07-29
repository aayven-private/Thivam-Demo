//
//  IBActionPad.h
//  thivam
//
//  Created by Ivan Borsa on 23/09/14.
//  Copyright (c) 2014 ivanborsa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPMatrix.h"
#import "TPActionNode.h"
#import "TPActionDescriptor.h"
#import "TPConnectionDescriptor.h"
#import "CommonTools.h"

typedef id<TPActionNodeActor>(^nodeInit)(int row, int column);

extern NSString *const kConnectionTypeKey;
extern NSString *const kConnectionParameter_counter;
extern NSString *const kConnectionParameter_dispersion;
extern NSString *const kConnectionParameter_autoFire;
extern NSString *const kConnectionParameter_repeatCount;

extern NSString *const kConnectionTypeRandom;
extern NSString *const kConnectionTypeCustom;

extern NSString *const kNeighborTop;
extern NSString *const kNeighborBottom;
extern NSString *const kNeighborLeft;
extern NSString *const kNeighborRight;

extern NSString *const kNeighborTopLeft;
extern NSString *const kNeighborTopRight;
extern NSString *const kNeighborBottomLeft;
extern NSString *const kNeighborBottomRight;

@interface TriggerPad : NSObject<TPActionNodeControllerDelegate>

@property (nonatomic) TPMatrix *objectGrid;
@property (copy) nodeInit initRule;
@property (nonatomic) NSString *connectionType;
@property (nonatomic) NSMutableDictionary *unifiedActionDescriptors;
@property (nonatomic) CGFloat coolDownPeriod;
@property (nonatomic) CGSize gridSize;
@property (nonatomic) BOOL isRecording;
@property (nonatomic) int actionHeapSize;
@property (nonatomic) NSMutableArray *cancelEventIds;

+(id)setUpGridWithSize:(CGSize)gridSize andNodeInitBlock:(nodeInit)initBlock andActionHeapSize:(int)actionHeapSize;

-(id)initGridWithSize:(CGSize)size andNodeInitBlock:(nodeInit)initBlock andActionHeapSize:(int)actionHeapSize;
-(void)createGridWithNodesActivated:(BOOL)isActivated;
-(void)createRecordGrid;
-(TPActionNode *)getNodeAtPosition:(CGPoint)position;
-(void)loadConnectionMapWithDescriptor:(TPConnectionDescriptor *)connectionDescriptor forActionType:(NSString *)actionType;
-(void)loadConnectionMapWithDescriptor:(TPConnectionDescriptor *)connectionDescriptor forActionType:(NSString *)actionType withNodeValueReset:(BOOL)valueReset;
-(BOOL)addConnectionFromPosition:(CGPoint)sourcePosition toPosition:(CGPoint)destinationPosition forActionType:(NSString *)actionType;
-(void)removeConnectionsForActionType:(NSString *)actionType;
-(void)triggerNodeAtPosition:(CGPoint)position
                forActionType:(NSString *)actionType
                withuserInfo:(NSMutableDictionary *)userInfo;
-(void)triggerNodeAtPosition:(CGPoint)position
                forActionType:(NSString *)actionType
                withuserInfo:(NSMutableDictionary *)userInfo
                withNodeReset:(BOOL)reset;
-(void)triggerNodeAtPosition:(CGPoint)position
                forActionType:(NSString *)actionType
                withuserInfo:(NSMutableDictionary *)userInfo
                withNodeReset:(BOOL)reset
                withActionId:(NSString *)actionId;
-(void)triggerNodeAtPosition:(CGPoint)position
                forActionType:(NSString *)actionType
                withuserInfo:(NSMutableDictionary *)userInfo
                withNodeReset:(BOOL)reset
                withActionId:(NSString *)actionId
                andPassProbability:(double)probability;
-(void)triggerNodeAtPosition:(CGPoint)position
                forActionType:(NSString *)actionType
                withuserInfo:(NSMutableDictionary *)userInfo
                withNodeReset:(BOOL)reset
                withActionId:(NSString *)actionId
                andNodeValueModifier:(double)valueModifier;
-(void)triggerNodeAtPosition:(CGPoint)position
                forActionType:(NSString *)actionType
                withuserInfo:(NSMutableDictionary *)userInfo
                withNodeReset:(BOOL)reset
                withActionId:(NSString *)actionId
                andNodeValueModifier:(double)valueModifier
                forValueType:(NSString *)valueType;
-(void)triggerNodeAtPosition:(CGPoint)position
                forActionType:(NSString *)actionType
                withuserInfo:(NSMutableDictionary *)userInfo
                withNodeReset:(BOOL)reset
                withActionId:(NSString *)actionId
                andNodeValueModifier:(double)valueModifier
                forValueType:(NSString *)valueType
                andPassProbability:(double)probability;
-(void)clearActionPad;
-(void)setActions:(NSArray *)actions forNodeAtPosition:(CGPoint)position forActionType:(NSString *)actionType;
-(void)setnodeActivated:(BOOL)isActive atPosition:(CGPoint)position;
-(NSArray *)getUnifiedActionDescriptorsForActionType:(NSString *)actionType;
-(void)setNodeValuesTo:(double)nodeValue forActionType:(NSString *)actionType;
-(void)modifyNodeValueAtPoint:(CGPoint)position withValue:(double)valueModifier forActionType:(NSString *)actionType;
-(double)getNodeValueAtPosition:(CGPoint)position forActionType:(NSString *)actionType;
-(void)fireNodeActionAtPosition:(CGPoint)position forActionType:(NSString *)actionType withUserinfo:(NSMutableDictionary *)userInfo;

@end
