//
//  GameScene.m
//  ap-effects
//
//  Created by Ivan Borsa on 08/01/15.
//  Copyright (c) 2015 ivanborsa. All rights reserved.
//

#import "GameScene.h"
#import "NodeObject.h"
#import "CommonTools.h"
#import "ToneGenerator.h"
#import "ButtonNode.h"

#import <TriggerPad.h>

@interface GameScene()

@property (nonatomic) NSTimeInterval checkInterval;
@property (nonatomic) NSTimeInterval effectInterval;
@property (nonatomic) NSTimeInterval lastTimerUpdateTimeInterval;
@property (nonatomic) NSTimeInterval lastEffectInterval;

@property (nonatomic) SKSpriteNode *paintArea;
@property (nonatomic) SKSpriteNode *effectPadHolder;
//@property (nonatomic) IBActionPad *effectPad;

@property (nonatomic) CGSize gridSize;

@property (nonatomic) NSMutableArray *effects;
@property (nonatomic) NSMutableArray *combos;

@property (nonatomic) TPConnectionDescriptor *effectConnection;
@property (nonatomic) TPConnectionDescriptor *selectConnection;
@property (nonatomic) TPConnectionDescriptor *clearConnection;
@property (nonatomic) TPConnectionDescriptor *wallBuilderConnection;

@property (nonatomic) int currentEffectIndex;

@property (nonatomic) TPActionDescriptor *permAct;
@property (nonatomic) int currentActionNodes;

@property (nonatomic) NodeObject *selectedNode;

@property (nonatomic) double maxLen;

@property (nonatomic) BOOL actionsAllowed;

@property (nonatomic) NSString *currentActionId;

@property (nonatomic) NSTimer *longTapTimer;
@property (nonatomic) NodeObject *currentLongTapNode;
@property (nonatomic) BOOL isLongTap;

@property (nonatomic) SKSpriteNode *timerBaseNode;
@property (nonatomic) SKLabelNode *timerLabel;
@property (nonatomic) NSTimeInterval startInterval;

//------
@property (nonatomic) CGSize nodeSize;
@property (nonatomic) UIImage *baseImage;
//@property (nonatomic) CGSize imageGridSize;

@property (nonatomic) CGPoint lastActingNodePosition;

@property (nonatomic) NSMutableArray *targetColors;
//@property (nonatomic) UIColor *penColor;

@property (nonatomic) NodeObject *mainActorNode;

@property (nonatomic) double effectSpeed;

@property (nonatomic) SKSpriteNode *cameraButton;

@property (nonatomic) int colorCycle;

@property (nonatomic) double effectValue;

@property (nonatomic) Boolean even;

//---------

@property (nonatomic) NSTimeInterval playbackInterval;
@property (nonatomic) NSEnumerator *currentPlaybackEnumerator;
@property (nonatomic) NSEnumerator *gestureEnumerator;

@property (nonatomic) ButtonNode *playButton;
@property (nonatomic) ButtonNode *colorPickerButton;
@property (nonatomic) ButtonNode *effectsButton;
@property (nonatomic) ButtonNode *clearButton;

@property (nonatomic) ButtonNode *saveButton;
@property (nonatomic) ButtonNode *backButton;
@property (nonatomic) ButtonNode *addScenebutton;

@property (nonatomic) NSArray *currentEffects;

@property (nonatomic) CGPoint currentStartPoint;

@property (nonatomic) NSMutableDictionary *effectsByNames;

@property (nonatomic) SKSpriteNode *effectsPanel;
@property (nonatomic) BOOL isEffectsPanelOnScreen;
@property (nonatomic) BOOL isPlayback;

@property (nonatomic) NSString *currentEffectName;

@property (nonatomic) TriggerPad *effectPad;

@property (nonatomic) BOOL randomizePenColor;
@property (nonatomic) BOOL isDisappearing;

@property (nonatomic) UIColor *baseColor;

@property (nonatomic) BOOL isClearing;
@property (nonatomic) int currentWipeCounter;
@property (nonatomic) int currentClearCounter;

@property (nonatomic) NSArray *clearGestureAction;

@property (nonatomic) CGPoint triggerPoint;

@property (nonatomic) UIColor *nextColor;

@end

@implementation GameScene

//@synthesize effectPad = _effectPad;

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
    [self initScene];
}

-(void)initScene
{
//    NSLog(@"Self size: %f:%f", self.size.width, self.size.height);
    self.baseImage = [UIImage imageNamed:@"test2"];
    CGSize imageSize = self.baseImage.size;
    
    self.even = false;
    
    CGSize translatedSize = CGSizeZero;
    double ratio = 1.0;
    
    if (imageSize.height / imageSize.width > self.size.height / self.size.width) {
        // Image is "longer" than screen
        ratio = self.size.height / imageSize.height;
        translatedSize = CGSizeMake(imageSize.width * ratio, self.size.height);
    } else {
        // Image is "wider" then the screen
        ratio = self.size.width / imageSize.width;
        translatedSize = CGSizeMake(self.size.width, imageSize.height * ratio);
    }
    
//    NSLog(@"Size before: %f:%f", self.baseImage.size.width, self.baseImage.size.height);
    self.baseImage = [self imageWithImage:self.baseImage convertToSize:self.size];
    
//    NSLog(@"Size after: %f:%f", self.baseImage.size.width, self.baseImage.size.height);
    
    self.selectedNode = nil;
    self.backgroundColor = [UIColor whiteColor];
    self.currentEffectIndex = 0;
    self.currentActionNodes = 0;
    self.actionsAllowed = NO;
    self.effects = [NSMutableArray array];
    self.combos = [NSMutableArray array];
    self.currentLongTapNode = nil;
    self.isLongTap = NO;
    self.lastTimerUpdateTimeInterval = 0;
    self.lastEffectInterval = 0;
    self.checkInterval = 1;
    //self.effectInterval = [CommonTools getRandomFloatFromFloat:.5 toFloat:1.5];
    self.effectInterval = 3;
    self.mainActorNode = nil;
    self.targetColors = [NSMutableArray arrayWithObjects:[UIColor blueColor], [UIColor greenColor], [UIColor yellowColor], [UIColor magentaColor], [UIColor purpleColor], [UIColor redColor], [UIColor cyanColor], [UIColor orangeColor], nil];
    self.targetColors = [NSMutableArray arrayWithObjects:[CommonTools stringToColor:@"F51329"], [CommonTools stringToColor:@"F98020"], [CommonTools stringToColor:@"F9EB18"], [CommonTools stringToColor:@"9BEC1A"], [CommonTools stringToColor:@"3DDE1E"], nil];
    //self.targetColors = [NSMutableArray arrayWithObjects:[CommonTools stringToColor:@"1E9600"], [CommonTools stringToColor:@"FFF200"], [CommonTools stringToColor:@"FF0000"], nil];
    self.effectSpeed = 3;
    self.colorCycle = 0;
    self.effectValue = 0;
    self.currentStartPoint = CGPointMake(-1, -1);
    self.effectsByNames = [NSMutableDictionary dictionary];
    self.isEffectsPanelOnScreen = NO;
    self.isPlayback = NO;
    self.randomizePenColor = YES;
    self.isDisappearing = NO;
    self.currentClearCounter = 0;
    self.currentWipeCounter = 0;
    self.isClearing = NO;
    self.baseColor = [UIColor redColor];
    self.triggerPoint = CGPointMake(-1, -1);
    self.nextColor = [self.targetColors objectAtIndex:[CommonTools getRandomNumberFromInt:0 toInt:(int)self.targetColors.count - 1]];
    self.anchorPoint = CGPointMake(.5, .5);
    
    self.currentActionId = [[NSUUID UUID] UUIDString];
    
    _effectPadHolder = [[SKSpriteNode alloc] initWithColor:[UIColor blackColor] size:CGSizeMake(self.size.width, self.size.height)];
    _effectPadHolder.anchorPoint = CGPointMake(.5, .5);
    _effectPadHolder.position = CGPointMake(0, 0);
    [self addChild:_effectPadHolder];
    
    _gridSize = CGSizeMake(30, 50);
    _nodeSize = CGSizeMake(_effectPadHolder.size.width / _gridSize.width, _effectPadHolder.size.height / _gridSize.height);
    __weak GameScene *weakSelf = self;
    self.effectPad = [[TriggerPad alloc] initGridWithSize:_gridSize andNodeInitBlock:^id<TPActionNodeActor>(int row, int column) {
//        int translatedColumn = abs(column - weakSelf.gridSize.width + 1);
        int translatedRow = abs(row - (int)weakSelf.gridSize.height + 1);
        
        CGPoint blockPosition = CGPointMake(column * weakSelf.nodeSize.width - weakSelf.effectPadHolder.size.width / 2.0 + weakSelf.nodeSize.width / 2.0, row * weakSelf.nodeSize.height - weakSelf.effectPadHolder.size.height / 2.0 + weakSelf.nodeSize.height / 2.0);
        
        CGPoint pixelPosition = CGPointMake(column * weakSelf.nodeSize.width + weakSelf.nodeSize.width / 2.0, translatedRow * weakSelf.nodeSize.height + weakSelf.nodeSize.height / 2.0);
//        UIColor *pixelColor = [weakSelf getPixelColorAtLocation:pixelPosition onImage:weakSelf.baseImage];
        
        CGPoint topLeftCenter = CGPointMake(pixelPosition.x - weakSelf.nodeSize.width / 4.0, pixelPosition.y + weakSelf.nodeSize.height / 4.0);
        CGPoint topRightCenter = CGPointMake(pixelPosition.x + weakSelf.nodeSize.width / 4.0, pixelPosition.y + weakSelf.nodeSize.height / 4.0);
        CGPoint bottomLeftCenter = CGPointMake(pixelPosition.x - weakSelf.nodeSize.width / 4.0, pixelPosition.y - weakSelf.nodeSize.height / 4.0);
        CGPoint bottomRightCenter = CGPointMake(pixelPosition.x + weakSelf.nodeSize.width / 4.0, pixelPosition.y - weakSelf.nodeSize.height / 4.0);
        
        
        UIColor *topLeftColor = [weakSelf getPixelColorAtLocation:topLeftCenter onImage:weakSelf.baseImage];
        UIColor *topRightColor = [weakSelf getPixelColorAtLocation:topRightCenter onImage:weakSelf.baseImage];
        UIColor *bottomLeftColor = [weakSelf getPixelColorAtLocation:bottomLeftCenter onImage:weakSelf.baseImage];
        UIColor *bottomRightColor = [weakSelf getPixelColorAtLocation:bottomRightCenter onImage:weakSelf.baseImage];
        
        NodeObject *node = [[NodeObject alloc] initWithSize:CGSizeMake(_nodeSize.width + 1, _nodeSize.height + 1)];
        [node setupNodeWithColors:[NSArray arrayWithObjects:topLeftColor, topRightColor, bottomLeftColor, bottomRightColor, nil]];
//        [node setupNodeWithColors:[NSArray arrayWithObjects:pixelColor, pixelColor, pixelColor, pixelColor, nil]];
        node.anchorPoint = CGPointMake(.5, .5);
        
        
        node.position = blockPosition;
        
        node.initialScreenPosition = blockPosition;
        node.columnIndex = column;
        node.rowIndex = row;
        
        
        [weakSelf.effectPadHolder addChild:node];
        
        return node;
    } andActionHeapSize:30];
    
    [self.effectPad createGridWithNodesActivated:YES];
    
    _effectConnection = [[TPConnectionDescriptor alloc] init];
    _effectConnection.connectionType = kConnectionTypeCustom;
    _effectConnection.isAutoFired = YES;
    _effectConnection.ignoreActionId = NO;
    _effectConnection.autoFireDelay = .04;
    _effectConnection.autoFireDispersion = 0.03;
    _effectConnection.nodeValue = [NSNumber numberWithDouble:1.0];
    _effectConnection.isPipedConnection = NO;
    _effectConnection.connectionMap = [NSMutableArray arrayWithObjects:kNeighborLeft, kNeighborRight, kNeighborTop, kNeighborBottom, nil];
    //_effectConnection.firePriorities = [NSMutableArray arrayWithObjects:@"b", @"l,r", nil];
    //_effectConnection.connectionFireThreshold = .5;
    
    [self.effectPad loadConnectionMapWithDescriptor:_effectConnection forActionType:@"action"];

    [self loadEffects];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.even = !self.even;
    self.baseImage = self.even ? [UIImage imageNamed:@"test3"] : [UIImage imageNamed:@"test2"];
    CGSize imageSize = self.baseImage.size;
    
    
    CGSize translatedSize = CGSizeZero;
    double ratio = 1.0;
    
    if (imageSize.height / imageSize.width > self.size.height / self.size.width) {
        // Image is "longer" than screen
        ratio = self.size.height / imageSize.height;
        translatedSize = CGSizeMake(imageSize.width * ratio, self.size.height);
    } else {
        // Image is "wider" then the screen
        ratio = self.size.width / imageSize.width;
        translatedSize = CGSizeMake(self.size.width, imageSize.height * ratio);
    }
    
    //    NSLog(@"Size before: %f:%f", self.baseImage.size.width, self.baseImage.size.height);
    self.baseImage = [self imageWithImage:self.baseImage convertToSize:self.size];
    
    self.currentActionId = [[NSUUID UUID] UUIDString];
    self.nextColor = [self.targetColors objectAtIndex:[CommonTools getRandomNumberFromInt:0 toInt:(int)self.targetColors.count - 1]];
    [self loadNextEffect];
    
    /*UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:_effectPadHolder];
    
    int xCoord = (_gridSize.width * (location.x + _effectPadHolder.size.width / 2)) / _effectPadHolder.size.width;
    int yCoord = (_gridSize.height * (location.y + _effectPadHolder.size.height / 2)) / _effectPadHolder.size.height;
    
    _triggerPoint = CGPointMake(xCoord, yCoord);
    [_effectPad triggerNodeAtPosition:_triggerPoint forActionType:@"action" withuserInfo:[NSMutableDictionary dictionary] withNodeReset:NO withActionId:_currentActionId];*/
    
}

-(void)switchSettingsMenu
{
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:_effectPadHolder];
    
    int xCoord = (_gridSize.width * (location.x + _effectPadHolder.size.width / 2)) / _effectPadHolder.size.width;
    int yCoord = (_gridSize.height * (location.y + _effectPadHolder.size.height / 2)) / _effectPadHolder.size.height;
    
    _triggerPoint = CGPointMake(xCoord, yCoord);
    [_effectPad triggerNodeAtPosition:_triggerPoint forActionType:@"action" withuserInfo:[NSMutableDictionary dictionary] withNodeReset:NO withActionId:_currentActionId];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void)longTap:(NSTimer *)timer
{
    _isLongTap = YES;
    [_longTapTimer invalidate];
    _longTapTimer = nil;
    [_currentLongTapNode runAction:[SKAction scaleTo:1.2 duration:.2]];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    CFTimeInterval timeSinceLast = currentTime - self.lastTimerUpdateTimeInterval;
    self.lastTimerUpdateTimeInterval = currentTime;
    if (timeSinceLast > 1) { // more than a second since last update
        timeSinceLast = 1.0 / 60.0;
        self.lastTimerUpdateTimeInterval = currentTime;
    }
    if (!self.paused) {
        [self updateWithTimeSinceLastUpdate:timeSinceLast];
    }
}

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)timeSinceLast {

}

-(NSArray *)getClearGestureAction
{
    return _clearGestureAction;
}

-(void)loadEffects_simple
{
    __weak GameScene *weakSelf = self;
    
    _permAct = [[TPActionDescriptor alloc] init];
    _permAct.action = ^(id<TPActionNodeActor>target, NSDictionary *userInfo) {
        NodeObject *targetNode = (NodeObject *)target;
        
        weakSelf.currentActionNodes++;
        /*[targetNode runAction:[SKAction sequence:@[[SKAction waitForDuration:.3], [SKAction runBlock:^{
            targetNode.color = [CommonTools getRandomColorCloseToColor:weakSelf.nextColor withDispersion:.3];
        }]]]];*/
        
        [targetNode runAction:[SKAction colorizeWithColor:weakSelf.nextColor colorBlendFactor:1 duration:.8]];

        if (weakSelf.currentActionNodes == (weakSelf.gridSize.width) * (weakSelf.gridSize.height)) {
            weakSelf.currentActionNodes = 0;
        }
    };
    
    //--------------------
    TPActionDescriptor *waveEffect = [[TPActionDescriptor alloc] init];
    waveEffect.action = ^(id<TPActionNodeActor>target, NSDictionary *userInfo) {
        NodeObject *targetNode = (NodeObject *)target;
        SKAction *scaleSequence = [SKAction sequence:@[[SKAction scaleTo:.5 duration:.4], [SKAction scaleTo:1 duration:.4]]];
        SKAction *nodeAction = [SKAction group:@[scaleSequence, [SKAction sequence:@[[SKAction fadeAlphaTo:.7 duration:.4], [SKAction fadeAlphaTo:1 duration:.4]]]]];
        [targetNode runAction:nodeAction];
    };
    waveEffect.actionName = @"wave";
    //--------------------
    
    //--------------------
    TPActionDescriptor *reverseWave = [[TPActionDescriptor alloc] init];
    reverseWave.action = ^(id<TPActionNodeActor>target, NSDictionary *userInfo) {
        NodeObject *targetNode = (NodeObject *)target;
        
        SKAction *scaleSequence = [SKAction sequence:@[[SKAction scaleTo:1.4 duration:.4], [SKAction scaleTo:1 duration:.4]]];
        SKAction *nodeAction = [SKAction group:@[scaleSequence, [SKAction sequence:@[[SKAction fadeAlphaTo:.5 duration:.4], [SKAction fadeAlphaTo:1 duration:.4]]]]];
        [targetNode runAction:nodeAction];
    };
    reverseWave.actionName = @"reverseWave";
    //--------------------
    
    //--------------------
    TPActionDescriptor *tornado = [[TPActionDescriptor alloc] init];
    tornado.action = ^(id<TPActionNodeActor>target, NSDictionary *userInfo) {
        NodeObject *targetNode = (NodeObject *)target;
        SKAction *scaleSequence = [SKAction sequence:@[[SKAction scaleTo:1.4 duration:.6], [SKAction scaleTo:1 duration:.6]]];
        SKAction *moveSequence = [SKAction sequence:@[[SKAction moveToX:targetNode.initialScreenPosition.x + weakSelf.nodeSize.width duration:.3],[SKAction moveToX:targetNode.initialScreenPosition.x duration:.3],  [SKAction moveToX:targetNode.initialScreenPosition.x - weakSelf.nodeSize.width duration:.3], [SKAction moveToX:targetNode.initialScreenPosition.x duration:.3]]];
        SKAction *nodeAction = [SKAction group:@[scaleSequence, moveSequence, [SKAction sequence:@[[SKAction fadeAlphaTo:.5 duration:.6], [SKAction fadeAlphaTo:1 duration:.6]]]]];
        [targetNode runAction:nodeAction];
    };
    tornado.actionName = @"tornado";
    //--------------------
    
    //--------------------
    TPActionDescriptor *hoolahoop = [[TPActionDescriptor alloc] init];
    hoolahoop.action = ^(id<TPActionNodeActor>target, NSDictionary *userInfo) {
        NodeObject *targetNode = (NodeObject *)target;
        
        SKAction *scaleSequence = [SKAction sequence:@[[SKAction scaleTo:1.4 duration:.4], [SKAction scaleTo:1 duration:.4]]];
        SKAction *moveSequence = [SKAction sequence:@[[SKAction moveToY:targetNode.initialScreenPosition.y + weakSelf.nodeSize.height duration:.3],[SKAction moveToY:targetNode.initialScreenPosition.y duration:.3],  [SKAction moveToY:targetNode.initialScreenPosition.y - weakSelf.nodeSize.height duration:.3], [SKAction moveToY:targetNode.initialScreenPosition.y duration:.3]]];
        SKAction *nodeAction = [SKAction group:@[scaleSequence, moveSequence, [SKAction sequence:@[[SKAction fadeAlphaTo:.5 duration:.4], [SKAction fadeAlphaTo:1 duration:.4]]]]];
        [targetNode runAction:nodeAction];
    };
    hoolahoop.actionName = @"hoolahoop";
    //--------------------
    
    //--------------------
    TPActionDescriptor *rotate = [[TPActionDescriptor alloc] init];
    rotate.action = ^(id<TPActionNodeActor>target, NSDictionary *userInfo) {
        NodeObject *targetNode = (NodeObject *)target;
        
        SKAction *nodeAction = [SKAction group:@[[SKAction rotateByAngle:M_PI duration:.4], [SKAction sequence:@[[SKAction fadeAlphaTo:.5 duration:.2], [SKAction fadeAlphaTo:1 duration:.2]]], [SKAction sequence:@[[SKAction scaleTo:.7 duration:.2], [SKAction scaleTo:1 duration:.2]]]]];
        [targetNode runAction:nodeAction];
    };
    rotate.actionName = @"rotate";
    //--------------------
    
    //--------------------
    TPActionDescriptor *shrink = [[TPActionDescriptor alloc] init];
    shrink.action = ^(id<TPActionNodeActor>target, NSDictionary *userInfo) {
        NodeObject *targetNode = (NodeObject *)target;
        
        CGPoint sourcePosition = ((NSValue *)[userInfo objectForKey:@"triggerNode"]).CGPointValue;
        NodeObject *sourceNode = (NodeObject *)([weakSelf.effectPad getNodeAtPosition:sourcePosition].nodeObject);
        
        double destX, destY;
        
        if (sourceNode.columnIndex < targetNode.columnIndex) {
            destX = targetNode.initialScreenPosition.x + weakSelf.nodeSize.height;
        } else if (sourceNode.columnIndex > targetNode.columnIndex) {
            destX = targetNode.initialScreenPosition.x - weakSelf.nodeSize.height;
        } else {
            destX = targetNode.initialScreenPosition.x;
        }
        
        if (sourceNode.rowIndex < targetNode.rowIndex) {
            destY = targetNode.initialScreenPosition.y + weakSelf.nodeSize.height;
        } else if (sourceNode.rowIndex > targetNode.rowIndex) {
            destY = targetNode.initialScreenPosition.y - weakSelf.nodeSize.height;
        } else {
            destY = targetNode.initialScreenPosition.y;
        }
        
        CGPoint targetPosition = CGPointMake(destX, destY);
        
        SKAction *nodeAction = [SKAction group:@[[SKAction rotateByAngle:M_PI duration:.4], [SKAction sequence:@[[SKAction group:@[[SKAction moveTo:targetPosition duration:.4], [SKAction fadeAlphaTo:.5 duration:.4], [SKAction scaleTo:.7 duration:.4]]], [SKAction group:@[[SKAction moveTo:targetNode.initialScreenPosition duration:.4], [SKAction fadeAlphaTo:1 duration:.4], [SKAction scaleTo:1 duration:.4]]]]]]];
        [targetNode runAction:nodeAction];
    };
    shrink.actionName = @"shrink";
    //--------------------
    
    //--------------------
    TPActionDescriptor *pulse = [[TPActionDescriptor alloc] init];
    pulse.action = ^(id<TPActionNodeActor>target, NSDictionary *userInfo) {
        NodeObject *targetNode = (NodeObject *)target;
        
        SKAction *nodeAction = [SKAction sequence:@[[SKAction scaleTo:1.5 duration:.2], [SKAction scaleTo:1 duration:.2]]];
        [targetNode runAction:nodeAction];
    };
    pulse.actionName = @"pulse";
    //--------------------
    
    //--------------------
    TPActionDescriptor *depulse = [[TPActionDescriptor alloc] init];
    depulse.action = ^(id<TPActionNodeActor>target, NSDictionary *userInfo) {
        NodeObject *targetNode = (NodeObject *)target;
        
        SKAction *nodeAction = [SKAction sequence:@[[SKAction scaleTo:.3 duration:.2], [SKAction scaleTo:1 duration:.2]]];
        [targetNode runAction:nodeAction];
    };
    depulse.actionName = @"depulse";
    //--------------------
    
    //--------------------
    TPActionDescriptor *shrink2 = [[TPActionDescriptor alloc] init];
    shrink2.action = ^(id<TPActionNodeActor>target, NSDictionary *userInfo) {
        NodeObject *targetNode = (NodeObject *)target;
        
        NSValue *sourcePositionValue = [userInfo objectForKey:@"triggerNode"];
        if (sourcePositionValue) {
            NodeObject *sourceNode = (NodeObject *)([weakSelf.effectPad getNodeAtPosition:sourcePositionValue.CGPointValue].nodeObject);
            
            SKAction *nodeAction = [SKAction sequence:@[[SKAction group:@[[SKAction rotateByAngle:M_PI duration:.3], [SKAction moveTo:sourceNode.initialScreenPosition duration:.3], [SKAction scaleTo:.3 duration:.3]]], [SKAction group:@[[SKAction moveTo:targetNode.initialScreenPosition duration:.3], [SKAction scaleTo:1 duration:.3]]]]];
            [targetNode runAction:nodeAction];
        }
    };
    shrink2.actionName = @"shrink2";
    //--------------------
    
    //--------------------
    TPActionDescriptor *whiplash = [[TPActionDescriptor alloc] init];
    whiplash.action = ^(id<TPActionNodeActor>target, NSDictionary *userInfo) {
        NodeObject *targetNode = (NodeObject *)target;
        NSValue *startPointValue = [userInfo objectForKey:@"startPoint"];
        CGPoint startPoint;
        if (!startPointValue) {
            startPoint = _currentStartPoint;
        } else {
            startPoint = startPointValue.CGPointValue;
        }
        
        NodeObject *startObject = (NodeObject *)[weakSelf.effectPad getNodeAtPosition:startPoint].nodeObject;
        SKAction *nodeAction = [SKAction sequence:@[[SKAction moveTo:startObject.initialScreenPosition duration:.5], [SKAction moveTo:targetNode.initialScreenPosition duration:.5]]];
        [targetNode runAction:nodeAction];
    };
    whiplash.actionName = @"whiplash";
    //--------------------
    
    //--------------------
    TPActionDescriptor *bulb = [[TPActionDescriptor alloc] init];
    bulb.action = ^(id<TPActionNodeActor>target, NSDictionary *userInfo) {
        NodeObject *targetNode = (NodeObject *)target;
        SKAction *nodeAction = [SKAction sequence:@[[SKAction scaleTo:1.5 duration:.2], [SKAction scaleTo:1 duration:.6]]];
        [targetNode runAction:nodeAction];
    };
    bulb.actionName = @"bulb";
    //--------------------
    
    //--------------------
    TPActionDescriptor *clearGesture = [[TPActionDescriptor alloc] init];
    clearGesture.action = ^(id<TPActionNodeActor>target, NSDictionary *userInfo) {
        NodeObject *targetNode = (NodeObject *)target;

        SKAction *clearColor = [SKAction colorizeWithColor:weakSelf.baseColor colorBlendFactor:1 duration:.2];

        [targetNode runAction:clearColor];
    };
    clearGesture.actionName = @"clear_gesture";
    _clearGestureAction = @[clearGesture];
    //--------------------
    
    //--------------------
    TPActionDescriptor *clear = [[TPActionDescriptor alloc] init];
    clear.action = ^(id<TPActionNodeActor>target, NSDictionary *userInfo) {
        NodeObject *targetNode = (NodeObject *)target;
        [targetNode removeAllActions];
        targetNode.position = targetNode.initialScreenPosition;
        SKAction *colorize = [SKAction colorizeWithColor:weakSelf.penColor colorBlendFactor:1 duration:.2];
        SKAction *clearColor = [SKAction colorizeWithColor:weakSelf.baseColor colorBlendFactor:1 duration:.2];
        SKAction *clearAction = [SKAction sequence:@[colorize, clearColor]];
        [targetNode runAction:clearAction];
    };
    clear.actionName = @"clear";
    [_effectPad.unifiedActionDescriptors setObject:@[clear] forKey:@"clear"];
    //--------------------
    
    //--------------------
    TPActionDescriptor *buildWall = [[TPActionDescriptor alloc] init];
    buildWall.action = ^(id<TPActionNodeActor>target, NSDictionary *userInfo) {
        NodeObject *targetNode = (NodeObject *)target;
        targetNode.color = [UIColor lightGrayColor];
        TPActionNode *node = [_effectPad getNodeAtPosition:CGPointMake(targetNode.columnIndex, targetNode.rowIndex)];
        [node.nodeValues setObject:[NSNumber numberWithDouble:0] forKey:@"action"];
    };
    buildWall.actionName = @"buildwall";
    [_effectPad.unifiedActionDescriptors setObject:@[buildWall] forKey:@"buildwall"];
    //--------------------
    
    [_effectsByNames setObject:@[waveEffect, _permAct] forKey:@"Wave"];
    [_effectsByNames setObject:@[reverseWave, _permAct] forKey:@"Wave2"];
    [_effectsByNames setObject:@[tornado, _permAct] forKey:@"Tornado"];
    [_effectsByNames setObject:@[hoolahoop, _permAct] forKey:@"HoolaHoop"];
    [_effectsByNames setObject:@[rotate, _permAct] forKey:@"Rotate"];
    [_effectsByNames setObject:@[shrink, _permAct] forKey:@"Shrink"];
    [_effectsByNames setObject:@[pulse, _permAct] forKey:@"Pulse"];
    [_effectsByNames setObject:@[depulse, _permAct] forKey:@"Depulse"];
    [_effectsByNames setObject:@[shrink2, _permAct] forKey:@"Shrink2"];
    [_effectsByNames setObject:@[whiplash, _permAct] forKey:@"Whiplash"];
    [_effectsByNames setObject:@[bulb, _permAct] forKey:@"Bulb"];
    
    [_effects addObject:waveEffect];
    [_effects addObject:reverseWave];
    [_effects addObject:tornado];
    [_effects addObject:hoolahoop];
    [_effects addObject:rotate];
    [_effects addObject:shrink];
    [_effects addObject:pulse];
    [_effects addObject:depulse];
    [_effects addObject:shrink2];
    [_effects addObject:whiplash];
    [_effects addObject:bulb];
}

-(void)loadNextEffect
{
    _currentEffectIndex++;
    if (_currentEffectIndex == _effects.count) {
        _currentEffectIndex = 0;
    }
    
    TPActionDescriptor *currentEffect = [_effects objectAtIndex:_currentEffectIndex];
    [self.effectPad.unifiedActionDescriptors setObject:@[currentEffect, _permAct] forKey:@"action"];
    [self.effectPad.unifiedActionDescriptors setObject:@[currentEffect, _permAct] forKey:@"draw"];
    _currentEffects = [@[currentEffect, _permAct] mutableCopy];
}

-(void)loadRandomEffect
{
    int effectIndex = [CommonTools getRandomNumberFromInt:0 toInt:(int)_effectsByNames.allKeys.count - 1];
    NSString *effectNameKey = [_effectsByNames.allKeys objectAtIndex:effectIndex];
    NSArray *randomEffect = [_effectsByNames objectForKeyedSubscript:effectNameKey];
    [self.effectPad.unifiedActionDescriptors setObject:randomEffect forKey:@"action"];
    _currentEffectName = effectNameKey;
    _currentEffects = [randomEffect mutableCopy];
}

-(void)combineAllEffects
{
    NSMutableArray *allEffects = [_effects mutableCopy];
    [allEffects addObject:_permAct];
    [self.effectPad.unifiedActionDescriptors setObject:allEffects forKey:@"action"];
    _currentEffects = [allEffects mutableCopy];
}

-(void)loadCombo
{
    int comboIndex = [CommonTools getRandomNumberFromInt:0 toInt:(int)_combos.count - 1];
    NSMutableArray *combo = [[_combos objectAtIndex:comboIndex] mutableCopy];
    [combo addObject:_permAct];
    [self.effectPad.unifiedActionDescriptors setObject:combo forKey:@"action"];
    _currentEffects = [combo mutableCopy];
}

-(void)combineEffects
{
    NSMutableArray *effects = [NSMutableArray array];
    int effectCount= [CommonTools getRandomNumberFromInt:1 toInt:6];
    
    for (int i=0; i<effectCount; i++) {
        int effectIndex = [CommonTools getRandomNumberFromInt:0 toInt:(int)_effects.count - 1];
        TPActionDescriptor *effect = [_effects objectAtIndex:effectIndex];
        [effects addObject:effect];
    }
    
    [effects addObject:_permAct];
    
    [self.effectPad.unifiedActionDescriptors setObject:effects forKey:@"action"];
    _currentEffects = [effects mutableCopy];
}

-(void)colorPicked:(UIColor *)color withRandomize:(BOOL)randomize withDisappear:(BOOL)disappear
{
    _colorPickerButton.color = color;
    _randomizePenColor = randomize;
    _isDisappearing = disappear;
    _penColor = color;
}

-(NSArray *)getEffectByName:(NSString *)effectName
{
    return [_effectsByNames objectForKey:effectName];
}

-(TriggerPad *)getEffectPad
{
    return _effectPad;
}

-(void)loadEffects
{
    __weak GameScene *weakSelf = self;
    
    _permAct = [[TPActionDescriptor alloc] init];
    _permAct.action = ^(id<TPActionNodeActor>target, NSDictionary *userInfo) {
        NodeObject *targetNode = (NodeObject *)target;
        
        weakSelf.currentActionNodes++;
        /*[targetNode runAction:[SKAction sequence:@[[SKAction waitForDuration:.3], [SKAction runBlock:^{
            targetNode.color = [CommonTools getRandomColorCloseToColor:weakSelf.nextColor withDispersion:.3];
        }]]]];*/
        
        
        int column = targetNode.columnIndex;
        int row = targetNode.rowIndex;
        
        int translatedRow = abs(row - (int)weakSelf.gridSize.height + 1);
        
//        CGPoint blockPosition = CGPointMake(column * weakSelf.nodeSize.width - weakSelf.effectPadHolder.size.width / 2.0 + weakSelf.nodeSize.width / 2.0, row * weakSelf.nodeSize.height - weakSelf.effectPadHolder.size.height / 2.0 + weakSelf.nodeSize.height / 2.0);
        
        CGPoint pixelPosition = CGPointMake(column * weakSelf.nodeSize.width + weakSelf.nodeSize.width / 2.0, translatedRow * weakSelf.nodeSize.height + weakSelf.nodeSize.height / 2.0);
//        UIColor *pixelColor = [weakSelf getPixelColorAtLocation:pixelPosition onImage:weakSelf.baseImage];
        
        CGPoint topLeftCenter = CGPointMake(pixelPosition.x - weakSelf.nodeSize.width / 4.0, pixelPosition.y + weakSelf.nodeSize.height / 4.0);
        CGPoint topRightCenter = CGPointMake(pixelPosition.x + weakSelf.nodeSize.width / 4.0, pixelPosition.y + weakSelf.nodeSize.height / 4.0);
        CGPoint bottomLeftCenter = CGPointMake(pixelPosition.x - weakSelf.nodeSize.width / 4.0, pixelPosition.y - weakSelf.nodeSize.height / 4.0);
        CGPoint bottomRightCenter = CGPointMake(pixelPosition.x + weakSelf.nodeSize.width / 4.0, pixelPosition.y - weakSelf.nodeSize.height / 4.0);
        
        UIColor *topLeftColor = [weakSelf getPixelColorAtLocation:topLeftCenter onImage:weakSelf.baseImage];
        UIColor *topRightColor = [weakSelf getPixelColorAtLocation:topRightCenter onImage:weakSelf.baseImage];
        UIColor *bottomLeftColor = [weakSelf getPixelColorAtLocation:bottomLeftCenter onImage:weakSelf.baseImage];
        UIColor *bottomRightColor = [weakSelf getPixelColorAtLocation:bottomRightCenter onImage:weakSelf.baseImage];
        [targetNode setupNodeWithColors:[NSArray arrayWithObjects:topLeftColor, topRightColor, bottomLeftColor, bottomRightColor, nil]];
        
        [targetNode runAction:[SKAction colorizeWithColor:[UIColor clearColor] colorBlendFactor:1 duration:[CommonTools getRandomFloatFromFloat:1 toFloat:2]]];
        
        if (weakSelf.currentActionNodes == (weakSelf.gridSize.width) * (weakSelf.gridSize.height)) {
            weakSelf.currentActionNodes = 0;
        }
    };
    
    //--------------------
    TPActionDescriptor *waveEffect = [[TPActionDescriptor alloc] init];
    waveEffect.action = ^(id<TPActionNodeActor>target, NSDictionary *userInfo) {
        NodeObject *targetNode = (NodeObject *)target;
        
        float duration = [CommonTools getRandomFloatFromFloat:.2 toFloat:.6];
        
        SKAction *scaleSequence = [SKAction sequence:@[[SKAction scaleTo:.7 duration:duration * _effectSpeed], [SKAction scaleTo:1 duration:duration * _effectSpeed]]];
        
        CGPoint sourcePosition = ((NSValue *)[userInfo objectForKey:@"startPoint"]).CGPointValue;
        NodeObject *sourceNode = (NodeObject *)([self.effectPad getNodeAtPosition:sourcePosition].nodeObject);
        
        int dX = abs(sourceNode.columnIndex - targetNode.columnIndex);
        int dY = abs(sourceNode.rowIndex - targetNode.rowIndex);
        double dist = sqrt(pow(dX, 2) + pow(dY, 2));
        
        CGPoint vec = rwMult(rwNormalize(rwSub(sourceNode.initialScreenPosition, targetNode.initialScreenPosition)), dist <= 16 ? dist : 16);
        
        SKAction *moveSequence = [SKAction sequence:@[[SKAction moveTo:rwAdd(targetNode.initialScreenPosition, vec) duration:duration * _effectSpeed], [SKAction moveTo:targetNode.initialScreenPosition duration:duration * _effectSpeed]]];
        
        [targetNode runAction:[SKAction group:@[scaleSequence, moveSequence, [SKAction sequence:@[[SKAction fadeAlphaTo:.7 duration:duration * _effectSpeed], [SKAction fadeAlphaTo:1 duration:duration * _effectSpeed]]]]]];
        
        //double scale = [_effectPad getNodeValueAtPosition:CGPointMake(targetNode.columnIndex, targetNode.rowIndex) forActionType:@"action"];
        
        //[targetNode runAction:[SKAction scaleTo:scale duration:.1]];
        
    };
    waveEffect.actionName = @"wave";
    
    //--------------------
    
    //--------------------
    TPActionDescriptor *reverseWave = [[TPActionDescriptor alloc] init];
    reverseWave.action = ^(id<TPActionNodeActor>target, NSDictionary *userInfo) {
        float duration = [CommonTools getRandomFloatFromFloat:.2 toFloat:.6];
        NodeObject *targetNode = (NodeObject *)target;
        
        SKAction *scaleSequence = [SKAction sequence:@[[SKAction scaleTo:1.4 duration:duration * _effectSpeed], [SKAction scaleTo:1 duration:duration * _effectSpeed]]];
        
        CGPoint sourcePosition = ((NSValue *)[userInfo objectForKey:@"startPoint"]).CGPointValue;
        NodeObject *sourceNode = (NodeObject *)([self.effectPad getNodeAtPosition:sourcePosition].nodeObject);
        
        int dX = abs(sourceNode.columnIndex - targetNode.columnIndex);
        int dY = abs(sourceNode.rowIndex - targetNode.rowIndex);
        double dist = sqrt(pow(dX, 2) + pow(dY, 2));
        
        CGPoint vec = rwMult(rwNormalize(rwSub(targetNode.initialScreenPosition, sourceNode.initialScreenPosition)), dist <= 16 ? dist : 16);
        
        SKAction *moveSequence = [SKAction sequence:@[[SKAction moveTo:rwAdd(targetNode.initialScreenPosition, vec) duration:duration * _effectSpeed], [SKAction moveTo:targetNode.initialScreenPosition duration:duration * _effectSpeed]]];
        
        [targetNode runAction:[SKAction group:@[scaleSequence, moveSequence, [SKAction sequence:@[[SKAction fadeAlphaTo:.5 duration:duration * _effectSpeed], [SKAction fadeAlphaTo:1 duration:duration * _effectSpeed]]]]]];
        
        //double scale = [_effectPad getNodeValueAtPosition:CGPointMake(targetNode.columnIndex, targetNode.rowIndex) forActionType:@"action"];
        
        //[targetNode runAction:[SKAction scaleTo:scale duration:.1]];
        
    };
    reverseWave.actionName = @"reverseWave";
    
    //--------------------
    
    //--------------------
    TPActionDescriptor *pushEffect = [[TPActionDescriptor alloc] init];
    pushEffect.action = ^(id<TPActionNodeActor>target, NSDictionary *userInfo) {
        float duration = [CommonTools getRandomFloatFromFloat:.2 toFloat:.6];
        NodeObject *targetNode = (NodeObject *)target;
        
        CGPoint sourcePosition = ((NSValue *)[userInfo objectForKey:@"startPoint"]).CGPointValue;
        NodeObject *sourceNode = (NodeObject *)([self.effectPad getNodeAtPosition:sourcePosition].nodeObject);
        
        int dX = abs(sourceNode.columnIndex - targetNode.columnIndex);
        int dY = abs(sourceNode.rowIndex - targetNode.rowIndex);
        double dist = sqrt(pow(dX, 2) + pow(dY, 2));
        
        double maxDist = sqrt(pow(_gridSize.width, 2) + pow(_gridSize.height, 2));
        
        CGPoint vec = rwMult(rwNormalize(rwSub(targetNode.initialScreenPosition, sourceNode.initialScreenPosition)), dist * 7);
        
        
        SKAction *moveSequence = [SKAction sequence:@[[SKAction moveTo:rwAdd(targetNode.initialScreenPosition, vec) duration:duration * _effectSpeed], [SKAction moveTo:targetNode.initialScreenPosition duration:duration * _effectSpeed]]];
        SKAction *scaleSequence = [SKAction sequence:@[[SKAction scaleTo:1 - dist / maxDist duration:(duration / 2.0) * _effectSpeed], [SKAction scaleTo:1 duration:(duration / 2.0) * _effectSpeed]]];
        
        [targetNode runAction:[SKAction group:@[[SKAction rotateByAngle:M_PI duration:duration * _effectSpeed], moveSequence, scaleSequence, [SKAction sequence:@[[SKAction fadeAlphaTo:.5 duration:duration * _effectSpeed], [SKAction fadeAlphaTo:1 duration:duration * _effectSpeed]]]]]];
        
        //double scale = [_effectPad getNodeValueAtPosition:CGPointMake(targetNode.columnIndex, targetNode.rowIndex) forActionType:@"action"];
        
        //[targetNode runAction:[SKAction scaleTo:scale duration:.1]];
        
    };
    pushEffect.actionName = @"push";
    
    //--------------------
    
    //--------------------
    TPActionDescriptor *select = [[TPActionDescriptor alloc] init];
    select.action = ^(id<TPActionNodeActor>target, NSDictionary *userInfo) {
        float duration = [CommonTools getRandomFloatFromFloat:.2 toFloat:.6];
        NodeObject *targetNode = (NodeObject *)target;
        
        CGPoint sourcePosition = ((NSValue *)[userInfo objectForKey:@"startPoint"]).CGPointValue;
        NodeObject *sourceNode = (NodeObject *)([self.effectPad getNodeAtPosition:sourcePosition].nodeObject);
        
        CGPoint vec = rwMult(rwNormalize(rwSub(targetNode.initialScreenPosition, sourceNode.initialScreenPosition)), 10);
        
        
        int dX = abs(sourceNode.columnIndex - targetNode.columnIndex);
        int dY = abs(sourceNode.rowIndex - targetNode.rowIndex);
        double dist = sqrt(pow(dX, 2) + pow(dY, 2));
        
        double maxDist = sqrt(pow(_gridSize.width, 2) + pow(_gridSize.height, 2));
        
        //SKAction *moveSequence = [SKAction sequence:@[[SKAction moveTo:rwAdd(targetNode.initialScreenPosition, vec) duration:.4], [SKAction moveTo:targetNode.initialScreenPosition duration:.4]]];
        //SKAction *scaleSequence = [SKAction sequence:@[[SKAction scaleTo:1 - dist / maxDist duration:.2], [SKAction scaleTo:1 duration:.2]]];
        
        //[targetNode runAction:[SKAction group:@[moveSequence, scaleSequence, [SKAction colorizeWithColor:[UIColor greenColor] colorBlendFactor:1 duration:.4], [SKAction sequence:@[[SKAction fadeAlphaTo:.5 duration:.4], [SKAction fadeAlphaTo:1 duration:.4]]]]]];
        
        [targetNode runAction:[SKAction sequence:@[[SKAction group:@[[SKAction moveTo:rwAdd(targetNode.initialScreenPosition, vec) duration:(duration / 2.0) * _effectSpeed], [SKAction scaleTo:1 + ((maxDist - dist) / maxDist) / 5 duration:(duration / 2.0) * _effectSpeed], [SKAction fadeAlphaTo:1 - (dist / maxDist) * 2 duration:(duration / 2.0) * _effectSpeed]]], [SKAction group:@[[SKAction moveTo:targetNode.initialScreenPosition duration:(duration / 2.0) * _effectSpeed], [SKAction scaleTo:1 duration:(duration / 2.0) * _effectSpeed], [SKAction fadeAlphaTo:1 duration:(duration / 2.0) * _effectSpeed]]]]]];
    };
    select.actionName = @"select";
    
    //--------------------
    
    //--------------------
    TPActionDescriptor *mirror_y = [[TPActionDescriptor alloc] init];
    mirror_y.action = ^(id<TPActionNodeActor>target, NSDictionary *userInfo) {
        NodeObject *targetNode = (NodeObject *)target;
        float duration = [CommonTools getRandomFloatFromFloat:.1 toFloat:.6];
        int targetColumn = _gridSize.width - 1 - targetNode.columnIndex;
        NodeObject *destNode = (NodeObject *)[self.effectPad getNodeAtPosition:CGPointMake(targetColumn, targetNode.rowIndex)].nodeObject;
        CGPoint targetPosition = destNode.initialScreenPosition;
        
        SKAction *mirrorAction = [SKAction sequence:@[[SKAction group:@[[SKAction rotateByAngle:M_PI duration:duration * _effectSpeed], [SKAction moveTo:targetPosition duration:duration * _effectSpeed], [SKAction sequence:@[[SKAction fadeAlphaTo:.5 duration:duration * _effectSpeed], [SKAction fadeAlphaTo:1 duration:duration * _effectSpeed]]], [SKAction sequence:@[[SKAction scaleTo:.7 duration:duration * _effectSpeed], [SKAction scaleTo:1 duration:duration * _effectSpeed]]]]], [SKAction group:@[[SKAction rotateByAngle:M_PI duration:duration * _effectSpeed], [SKAction moveTo:targetNode.initialScreenPosition duration:duration * _effectSpeed], [SKAction sequence:@[[SKAction fadeAlphaTo:.5 duration:duration * _effectSpeed], [SKAction fadeAlphaTo:1 duration:duration * _effectSpeed]]], [SKAction sequence:@[[SKAction scaleTo:.7 duration:duration * _effectSpeed], [SKAction scaleTo:1 duration:duration * _effectSpeed]]]]]]];
        
        //[targetNode runAction:[SKAction group:@[[SKAction rotateByAngle:M_PI duration:.4 * _effectSpeed], [SKAction moveTo:targetPosition duration:.4 * _effectSpeed], [SKAction sequence:@[[SKAction fadeAlphaTo:.5 duration:.2 * _effectSpeed], [SKAction fadeAlphaTo:1 duration:.2 * _effectSpeed]]], [SKAction sequence:@[[SKAction scaleTo:.7 duration:.2 * _effectSpeed], [SKAction scaleTo:1 duration:.2 * _effectSpeed]]]]]];
        
        [targetNode runAction:mirrorAction];
    };
    mirror_y.actionName = @"mirror_y";
    
    //--------------------
    
    //--------------------
    /*IBActionDescriptor *mirror_y_reverse = [[IBActionDescriptor alloc] init];
     mirror_y_reverse.action = ^(id<IBActionNodeActor>target, NSDictionary *userInfo) {
     NodeObject *targetNode = (NodeObject *)target;
     
     [targetNode runAction:[SKAction group:@[[SKAction rotateByAngle:M_PI duration:.4 * _effectSpeed], [SKAction moveTo:targetNode.initialScreenPosition duration:.4 * _effectSpeed], [SKAction sequence:@[[SKAction fadeAlphaTo:.5 duration:.2 * _effectSpeed], [SKAction fadeAlphaTo:1 duration:.2 * _effectSpeed]]], [SKAction sequence:@[[SKAction scaleTo:.7 duration:.2 * _effectSpeed], [SKAction scaleTo:1 duration:.2 * _effectSpeed]]]]]];
     };*/
    
    //[_effects addObject:mirror_y_reverse];
    //--------------------
    
    //--------------------
    TPActionDescriptor *mirror_x = [[TPActionDescriptor alloc] init];
    mirror_x.action = ^(id<TPActionNodeActor>target, NSDictionary *userInfo) {
        NodeObject *targetNode = (NodeObject *)target;
        float duration = [CommonTools getRandomFloatFromFloat:.2 toFloat:.6];
        int targetRow = _gridSize.height - 1 - targetNode.rowIndex;
        NodeObject *destNode = (NodeObject *)[self.effectPad getNodeAtPosition:CGPointMake(targetNode.columnIndex, targetRow)].nodeObject;
        CGPoint targetPosition = destNode.initialScreenPosition;
        
        SKAction *mirrorAction = [SKAction sequence:@[[SKAction group:@[[SKAction moveTo:targetPosition duration:duration * _effectSpeed], [SKAction sequence:@[[SKAction fadeAlphaTo:.5 duration:duration * _effectSpeed], [SKAction fadeAlphaTo:1 duration:.2 * _effectSpeed]]], [SKAction sequence:@[[SKAction scaleTo:.7 duration:.2 * _effectSpeed], [SKAction scaleTo:1 duration:duration * _effectSpeed]]]]], [SKAction group:@[[SKAction moveTo:targetNode.initialScreenPosition duration:.4 * _effectSpeed], [SKAction sequence:@[[SKAction fadeAlphaTo:.5 duration:.2 * _effectSpeed], [SKAction fadeAlphaTo:1 duration:.2 * _effectSpeed]]], [SKAction sequence:@[[SKAction scaleTo:.7 duration:.2 * _effectSpeed], [SKAction scaleTo:1 duration:duration * _effectSpeed]]]]]]];
        
        //[targetNode runAction:[SKAction group:@[[SKAction moveTo:targetPosition duration:.4 * _effectSpeed], [SKAction sequence:@[[SKAction fadeAlphaTo:.5 duration:.2 * _effectSpeed], [SKAction fadeAlphaTo:1 duration:.2 * _effectSpeed]]], [SKAction sequence:@[[SKAction scaleTo:.7 duration:.2 * _effectSpeed], [SKAction scaleTo:1 duration:.2 * _effectSpeed]]]]]];
        [targetNode runAction:mirrorAction];
    };
    mirror_x.actionName = @"mirror_x";
    
    //--------------------
    
    //--------------------
    /*IBActionDescriptor *mirror_x_reverse = [[IBActionDescriptor alloc] init];
     mirror_x_reverse.action = ^(id<IBActionNodeActor>target, NSDictionary *userInfo) {
     NodeObject *targetNode = (NodeObject *)target;
     
     [targetNode runAction:[SKAction group:@[[SKAction moveTo:targetNode.initialScreenPosition duration:.4 * _effectSpeed], [SKAction sequence:@[[SKAction fadeAlphaTo:.5 duration:.2 * _effectSpeed], [SKAction fadeAlphaTo:1 duration:.2 * _effectSpeed]]], [SKAction sequence:@[[SKAction scaleTo:.7 duration:.2 * _effectSpeed], [SKAction scaleTo:1 duration:.2 * _effectSpeed]]]]]];
     };*/
    
    //[_effects addObject:mirror_x_reverse];
    //--------------------
    
    //--------------------
    TPActionDescriptor *rotate = [[TPActionDescriptor alloc] init];
    rotate.action = ^(id<TPActionNodeActor>target, NSDictionary *userInfo) {
        NodeObject *targetNode = (NodeObject *)target;
        float duration = [CommonTools getRandomFloatFromFloat:.2 toFloat:.6];
        
        [targetNode runAction:[SKAction group:@[[SKAction rotateByAngle:M_PI duration:duration * _effectSpeed], [SKAction sequence:@[[SKAction fadeAlphaTo:.5 duration:duration * _effectSpeed], [SKAction fadeAlphaTo:1 duration:duration * _effectSpeed]]], [SKAction sequence:@[[SKAction scaleTo:.7 duration:duration * _effectSpeed], [SKAction scaleTo:1 duration:duration * _effectSpeed]]]]]];
    };
    rotate.actionName = @"rotate";
    
    //--------------------
    
    //--------------------
    TPActionDescriptor *shrink = [[TPActionDescriptor alloc] init];
    shrink.action = ^(id<TPActionNodeActor>target, NSDictionary *userInfo) {
        NodeObject *targetNode = (NodeObject *)target;
        float duration = [CommonTools getRandomFloatFromFloat:.2 toFloat:.6];
        CGPoint sourcePosition = ((NSValue *)[userInfo objectForKey:@"startPoint"]).CGPointValue;
        NodeObject *sourceNode = (NodeObject *)([self.effectPad getNodeAtPosition:sourcePosition].nodeObject);
        
        [targetNode runAction:[SKAction group:@[[SKAction rotateByAngle:M_PI duration:duration * _effectSpeed], [SKAction sequence:@[[SKAction group:@[[SKAction moveTo:sourceNode.position duration:duration * _effectSpeed], [SKAction fadeAlphaTo:.5 duration:duration * _effectSpeed], [SKAction scaleTo:.5 duration:duration * _effectSpeed]]], [SKAction group:@[[SKAction moveTo:targetNode.initialScreenPosition duration:duration * _effectSpeed], [SKAction fadeAlphaTo:1 duration:duration * _effectSpeed], [SKAction scaleTo:1 duration:duration * _effectSpeed]]]]]]]];
    };
    shrink.actionName = @"shrink";
    
    //--------------------
    
    //--------------------
    TPActionDescriptor *swarm = [[TPActionDescriptor alloc] init];
    swarm.action = ^(id<TPActionNodeActor>target, NSDictionary *userInfo) {
        NodeObject *targetNode = (NodeObject *)target;
        float duration = [CommonTools getRandomFloatFromFloat:.2 toFloat:.4];
        CGPoint sourcePosition = ((NSValue *)[userInfo objectForKey:@"startPoint"]).CGPointValue;
        NodeObject *sourceNode = (NodeObject *)([self.effectPad getNodeAtPosition:sourcePosition].nodeObject);
        
        CGPoint vec = rwSub(sourceNode.position, targetNode.position);
        double dist = rwLength(vec);
        
        [targetNode runAction:[SKAction group:@[[SKAction sequence:@[[SKAction moveTo:CGPointMake(targetNode.position.x + [CommonTools getRandomNumberFromInt:-1 toInt:1] * dist, sourceNode.position.y + [CommonTools getRandomNumberFromInt:-1 toInt:1] * dist) duration:duration * _effectSpeed], [SKAction moveTo:targetNode.initialScreenPosition duration:duration * _effectSpeed]]]]]];
    };
    swarm.actionName = @"swarm";
    
    //--------------------
    
    //[_effects removeAllObjects];
    
    //--------------------
    TPActionDescriptor *follow = [[TPActionDescriptor alloc] init];
    follow.action = ^(id<TPActionNodeActor>target, NSDictionary *userInfo) {
        NodeObject *targetNode = (NodeObject *)target;
        float duration = [CommonTools getRandomFloatFromFloat:.2 toFloat:.6];
        //CGPoint sourcePosition = ((NSValue *)[userInfo objectForKey:@"actionSource"]).CGPointValue;
        //NodeObject *sourceNode = (NodeObject *)([_effectPad getNodeAtPosition:sourcePosition].nodeObject);
        
        if (!_mainActorNode) {
            _mainActorNode = targetNode;
            CGPoint destination = CGPointMake(_gridSize.width - 1 - targetNode.columnIndex, _gridSize.height - 1 - targetNode.rowIndex);
            NodeObject *destNode = (NodeObject *)[self.effectPad getNodeAtPosition:destination].nodeObject;
            [targetNode runAction:[SKAction group:@[[SKAction sequence:@[[SKAction moveTo:destNode.position duration:duration * _effectSpeed], [SKAction moveTo:targetNode.initialScreenPosition duration:duration * _effectSpeed]]]]]];
        } else {
            [targetNode runAction:[SKAction group:@[[SKAction sequence:@[[SKAction moveTo:_mainActorNode.position duration:duration * _effectSpeed], [SKAction moveTo:targetNode.initialScreenPosition duration:duration * _effectSpeed]]]]]];
            _mainActorNode = nil;
            
        }
        
        /*CGPoint vec = rwSub(sourceNode.position, targetNode.position);
         double dist = rwLength(vec);
         
         [targetNode runAction:[SKAction group:@[[SKAction colorizeWithColor:[CommonTools getRandomColorCloseToColor:_nextColor withDispersion:.3] colorBlendFactor:1 duration:.8], [SKAction sequence:@[[SKAction moveTo:CGPointMake(targetNode.position.x + [CommonTools getRandomNumberFromInt:-1 toInt:1] * dist, sourceNode.position.y + [CommonTools getRandomNumberFromInt:-1 toInt:1] * dist) duration:.4], [SKAction moveTo:targetNode.initialScreenPosition duration:.4]]]]]];*/
    };
    follow.actionName = @"follow";
    
    //--------------------
    
    //[_effects removeAllObjects];
    
    //--------------------
    TPActionDescriptor *swarm2 = [[TPActionDescriptor alloc] init];
    swarm2.action = ^(id<TPActionNodeActor>target, NSDictionary *userInfo) {
        NodeObject *targetNode = (NodeObject *)target;
        float duration = [CommonTools getRandomFloatFromFloat:.2 toFloat:.6];
        
        CGPoint sourcePosition = ((NSValue *)[userInfo objectForKey:@"startPoint"]).CGPointValue;
        NodeObject *sourceNode = (NodeObject *)([self.effectPad getNodeAtPosition:sourcePosition].nodeObject);
        
        CGPoint vec = rwSub(sourceNode.position, targetNode.position);
        double dist = rwLength(vec);
        
        [targetNode runAction:[SKAction group:@[[SKAction sequence:@[[SKAction moveTo:CGPointMake(targetNode.position.x + [CommonTools getRandomNumberFromInt:-1 toInt:1] * dist, sourceNode.position.y + [CommonTools getRandomNumberFromInt:-1 toInt:1] * dist) duration:.4 * _effectSpeed], [SKAction moveTo:targetNode.initialScreenPosition duration:.4 * _effectSpeed]]]]]];
        
        if (!_mainActorNode) {
            _mainActorNode = targetNode;
            CGPoint destination = CGPointMake(_gridSize.width - 1 - targetNode.columnIndex, _gridSize.height - 1 - targetNode.rowIndex);
            NodeObject *destNode = _mainActorNode;
            [targetNode runAction:[SKAction group:@[[SKAction sequence:@[[SKAction moveTo:destNode.position duration:duration * _effectSpeed], [SKAction moveTo:targetNode.initialScreenPosition duration:duration * _effectSpeed]]]]]];
        } else {
            [targetNode runAction:[SKAction group:@[[SKAction sequence:@[[SKAction moveTo:CGPointMake(targetNode.position.x + [CommonTools getRandomNumberFromInt:-1 toInt:1] * dist, sourceNode.position.y + [CommonTools getRandomNumberFromInt:-1 toInt:1] * dist) duration:duration * _effectSpeed], [SKAction moveTo:targetNode.initialScreenPosition duration:duration * _effectSpeed]]]]]];
            _mainActorNode = nil;
        }
    };
    swarm2.actionName = @"swarm2";
    
    //--------------------
    
    //--------------------
    TPActionDescriptor *closer = [[TPActionDescriptor alloc] init];
    closer.action = ^(id<TPActionNodeActor>target, NSDictionary *userInfo) {
        NodeObject *targetNode = (NodeObject *)target;
        float duration = [CommonTools getRandomFloatFromFloat:.2 toFloat:.6];
        CGPoint destination = CGPointMake(_gridSize.width - 1 - targetNode.columnIndex, targetNode.rowIndex);
        NodeObject *destNode = (NodeObject *)[self.effectPad getNodeAtPosition:destination].nodeObject;
        
        if (_mainActorNode) {
            [targetNode runAction:[SKAction sequence:@[[SKAction group:@[[SKAction moveTo:destNode.position duration:duration * _effectSpeed], [SKAction fadeAlphaTo:.5 duration:duration * _effectSpeed], [SKAction scaleTo:.5 duration:duration * _effectSpeed]]], [SKAction group:@[[SKAction moveTo:targetNode.initialScreenPosition duration:duration * _effectSpeed], [SKAction fadeAlphaTo:1 duration:.4 * _effectSpeed], [SKAction scaleTo:1 duration:duration * _effectSpeed]]]]]];
            _mainActorNode = nil;
        } else {
            _mainActorNode = targetNode;
            [targetNode runAction:[SKAction sequence:@[[SKAction group:@[[SKAction moveTo:destNode.position duration:duration * _effectSpeed], [SKAction fadeAlphaTo:.5 duration:duration * _effectSpeed], [SKAction scaleTo:.5 duration:.4 * _effectSpeed]]], [SKAction group:@[[SKAction moveTo:targetNode.initialScreenPosition duration:duration * _effectSpeed], [SKAction fadeAlphaTo:1 duration:duration * _effectSpeed], [SKAction scaleTo:1 duration:duration * _effectSpeed]]]]]];
        }
    };
    closer.actionName = @"closer";
    
    //--------------------
    
    //[_effectPad.unifiedActionDescriptors setObject:@[swarm2, _permAct] forKey:@"action"];
    //[self loadRandomEffect];
    
    //--------------------
    TPActionDescriptor *draw = [[TPActionDescriptor alloc] init];
    draw.action = ^(id<TPActionNodeActor>target, NSDictionary *userInfo) {
        NodeObject *targetNode = (NodeObject *)target;
        float duration = [CommonTools getRandomFloatFromFloat:.4 toFloat:1.0];
        int targetColumn = _gridSize.width - 1 - targetNode.columnIndex;
        int targetRow = _gridSize.height - 1 - targetNode.rowIndex;
        
        CGPoint mirror_y = CGPointMake(targetColumn, targetNode.rowIndex);
        CGPoint mirror_x = CGPointMake(targetNode.columnIndex, targetRow);
        CGPoint mirror_x_y = CGPointMake(targetColumn, targetRow);
        
        NodeObject *destNode_x = (NodeObject *)[self.effectPad getNodeAtPosition:mirror_x].nodeObject;
        NodeObject *destNode_y = (NodeObject *)[self.effectPad getNodeAtPosition:mirror_y].nodeObject;
        NodeObject *destNode_x_y = (NodeObject *)[self.effectPad getNodeAtPosition:mirror_x_y].nodeObject;
        
        UIColor *nextColor = [userInfo objectForKey:@"nextColor"];
        
        targetNode.color = [CommonTools getRandomColorCloseToColor:nextColor withDispersion:.3];
        destNode_x.color = [CommonTools getRandomColorCloseToColor:nextColor withDispersion:.3];
        destNode_y.color = [CommonTools getRandomColorCloseToColor:nextColor withDispersion:.3];
        destNode_x_y.color = [CommonTools getRandomColorCloseToColor:nextColor withDispersion:.3];
        
        [targetNode runAction:[SKAction sequence:@[[SKAction fadeAlphaTo:1 duration:.2], [SKAction fadeAlphaTo:0 duration:duration]]]];
        /*if (_isMirror_x) {
         [destNode_x runAction:[SKAction sequence:@[[SKAction fadeAlphaTo:1 duration:.2], [SKAction fadeAlphaTo:0 duration:1.5]]]];
         }
         if (_isMirror_y) {
         [destNode_y runAction:[SKAction sequence:@[[SKAction fadeAlphaTo:1 duration:.2], [SKAction fadeAlphaTo:0 duration:1.5]]]];
         }
         if (_isMirror_x && _isMirror_y) {
         [destNode_x_y runAction:[SKAction sequence:@[[SKAction fadeAlphaTo:1 duration:.2], [SKAction fadeAlphaTo:0 duration:1.5]]]];
         }*/
    };
    [self.effectPad.unifiedActionDescriptors setObject:@[draw, _permAct] forKey:@"draw"];
    //--------------------
    
    //--------------------
    TPActionDescriptor *gestureWave = [[TPActionDescriptor alloc] init];
    gestureWave.action = ^(id<TPActionNodeActor>target, NSDictionary *userInfo) {
        NodeObject *targetNode = (NodeObject *)target;
        float duration = [CommonTools getRandomFloatFromFloat:.2 toFloat:.6];
        NSString *gestureId = [userInfo objectForKey:@"gestureId"];
        //if ([targetNode.gestureIds containsObject:gestureId]) {
        SKAction *scaleSequence = [SKAction sequence:@[[SKAction scaleTo:.7 duration:duration * _effectSpeed], [SKAction scaleTo:1 duration:duration * _effectSpeed]]];
        
        CGPoint sourcePosition = ((NSValue *)[userInfo objectForKey:@"startPoint"]).CGPointValue;
        NodeObject *sourceNode = (NodeObject *)([self.effectPad getNodeAtPosition:sourcePosition].nodeObject);
        
        int dX = abs(sourceNode.columnIndex - targetNode.columnIndex);
        int dY = abs(sourceNode.rowIndex - targetNode.rowIndex);
        double dist = sqrt(pow(dX, 2) + pow(dY, 2));
        
        CGPoint vec = rwMult(rwNormalize(rwSub(sourceNode.initialScreenPosition, targetNode.initialScreenPosition)), dist <= 16 ? dist : 16);
        
        SKAction *moveSequence = [SKAction sequence:@[[SKAction moveTo:rwAdd(targetNode.initialScreenPosition, vec) duration:duration * _effectSpeed], [SKAction moveTo:targetNode.initialScreenPosition duration:duration * _effectSpeed]]];
        
        [targetNode runAction:[SKAction group:@[scaleSequence, moveSequence, [SKAction sequence:@[[SKAction fadeAlphaTo:.7 duration:duration * _effectSpeed], [SKAction fadeAlphaTo:1 duration:duration * _effectSpeed]]]]]];
        //}
    };
    [self.effectPad.unifiedActionDescriptors setObject:@[gestureWave] forKey:@"gestureWave"];
    //--------------------
    
    
    NSArray *cmb1 = @[mirror_x, shrink, select];
    NSArray *cmb2 = @[select, follow, rotate];
    NSArray *cmb3 = @[waveEffect, closer, swarm2, follow];
    NSArray *cmb4 = @[reverseWave, swarm2, select];
    NSArray *cmb5 = @[mirror_x, follow];
    NSArray *cmb6 = @[mirror_y, follow];
    NSArray *cmb7 = @[mirror_x, swarm];
    NSArray *cmb8 = @[mirror_y, swarm];
    NSArray *cmb9 = @[mirror_x, swarm2];
    NSArray *cmb10 = @[mirror_y, swarm2];
    NSArray *cmb11 = @[shrink, swarm];
    NSArray *cmb12 = @[shrink, follow];
    NSArray *cmb13 = @[shrink, follow, swarm2];
    
    [_effectsByNames setObject:@[waveEffect, _permAct] forKey:@"waveEffect"];
    [_effectsByNames setObject:@[reverseWave, _permAct] forKey:@"reverseWave"];
    [_effectsByNames setObject:@[closer, _permAct] forKey:@"closer"];
    [_effectsByNames setObject:@[mirror_x, _permAct] forKey:@"mirror_x"];
    [_effectsByNames setObject:@[mirror_y, _permAct] forKey:@"mirror_y"];
    [_effectsByNames setObject:@[pushEffect, _permAct] forKey:@"pushEffect"];
    [_effectsByNames setObject:@[swarm2, _permAct] forKey:@"swarm2"];
    [_effectsByNames setObject:@[select, _permAct] forKey:@"select"];
    [_effectsByNames setObject:@[follow, _permAct] forKey:@"follow"];
    [_effectsByNames setObject:@[rotate, _permAct] forKey:@"rotate"];
    [_effectsByNames setObject:@[swarm, _permAct] forKey:@"swarm"];
    [_effectsByNames setObject:@[shrink, _permAct] forKey:@"shrink"];
    
    [_combos addObjectsFromArray:@[cmb1, cmb2, cmb3, cmb4, cmb5, cmb6, cmb7, cmb8, cmb9, cmb10, cmb11, cmb12, cmb13]];
    
    [_effects addObject:waveEffect];
    [_effects addObject:reverseWave];
    [_effects addObject:closer];
    [_effects addObject:mirror_y];
    [_effects addObject:mirror_x];
    [_effects addObject:pushEffect];
    [_effects addObject:swarm2];
    [_effects addObject:select];
    [_effects addObject:follow];
    [_effects addObject:rotate];
    [_effects addObject:swarm];
    [_effects addObject:shrink];
}

- (UIColor*) getPixelColorAtLocation:(CGPoint)point onImage: (UIImage *) sourceImage {
    UIColor* color = nil;
    CGImageRef inImage = sourceImage.CGImage;
    // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
    if (cgctx == NULL) { return nil; /* error */ }
    
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    /** Extra Added code for Resized Images ****/
    float xscale = w / self.frame.size.width;
    float yscale = h / self.frame.size.height;
    point.x = point.x * xscale;
    point.y = point.y * yscale;
    /** ****************************************/
    
    /** Extra Code Added for Resolution ***********/
    CGFloat x = 1.0;
    if ([sourceImage respondsToSelector:@selector(scale)]) x = sourceImage.scale;
    /*********************************************/
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, inImage);
    
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    unsigned char* data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        //offset locates the pixel in the data from x,y.
        //4 for 4 bytes of data per pixel, w is width of one row of data.
        //      int offset = 4*((w*round(point.y))+round(point.x));
        
        
        int offset = 4*((w*round(point.y))+round(point.x))*x; //Replacement for Resolution
        int alpha =  data[offset];
        int red = data[offset+1];
        int green = data[offset+2];
        int blue = data[offset+3];
//        NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
    }
    
    // When finished, release the context
    CGContextRelease(cgctx);
    // Free image data memory for the context
    if (data) { free(data); }
    
    return color;
}

- (CGContextRef)createARGBBitmapContextFromImage:(CGImageRef)inImage
{
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    void *bitmapData;
    int bitmapByteCount;
    int bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL)
    {
//        fprintf(stderr,"Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc(bitmapByteCount);
    if (bitmapData == NULL)
    {
//        fprintf(stderr,"Memory not allocated!");
        CGColorSpaceRelease(colorSpace);
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate(bitmapData,
                                    pixelsWide,
                                    pixelsHigh,
                                    8,   // bits per component
                                    bitmapBytesPerRow,
                                    colorSpace,
                                    kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free(bitmapData);
//        fprintf(stderr,"Context not created!");
    }
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease(colorSpace);
    
    return context;
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

@end
