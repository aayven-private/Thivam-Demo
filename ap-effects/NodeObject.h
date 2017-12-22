//
//  NodeObject.h
//  ap-effects
//
//  Created by Ivan Borsa on 08/01/15.
//  Copyright (c) 2015 ivanborsa. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <TPActionNodeActor.h>

@interface NodeObject : SKSpriteNode<TPActionNodeActor>

-(id)initWithSize:(CGSize)size;

@property (nonatomic) int rowIndex;
@property (nonatomic) int columnIndex;

@property (nonatomic) NodeObject *topLeftNode;
@property (nonatomic) NodeObject *topRightNode;
@property (nonatomic) NodeObject *bottomLeftNode;
@property (nonatomic) NodeObject *bottomRightNode;

@property (nonatomic) CGPoint initialScreenPosition;

-(void)setupNodeWithColors:(NSArray *) colors;

//@property (nonatomic) NSMutableArray *gestureIds;

@end
