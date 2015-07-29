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

@property (nonatomic) int rowIndex;
@property (nonatomic) int columnIndex;

@property (nonatomic) CGPoint initialScreenPosition;

//@property (nonatomic) NSMutableArray *gestureIds;

@end
