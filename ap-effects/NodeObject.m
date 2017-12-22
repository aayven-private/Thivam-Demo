//
//  NodeObject.m
//  ap-effects
//
//  Created by Ivan Borsa on 08/01/15.
//  Copyright (c) 2015 ivanborsa. All rights reserved.
//

#import "NodeObject.h"

@implementation NodeObject

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithColor:[UIColor clearColor] size:size]) {
        self.topLeftNode = [[NodeObject alloc] initWithColor:[UIColor redColor] size:CGSizeMake(size.width / 2.0, size.height / 2.0)];
        self.topLeftNode.anchorPoint = CGPointMake(0, 0);
        self.topLeftNode.position = CGPointMake(0, 0);
        
        self.topRightNode = [[NodeObject alloc] initWithColor:[UIColor greenColor] size:CGSizeMake(size.width / 2.0, size.height / 2.0)];
        self.topRightNode.anchorPoint = CGPointMake(0, 0);
        self.topRightNode.position = CGPointMake(size.width / 2.0, 0);
        
        self.bottomLeftNode = [[NodeObject alloc] initWithColor:[UIColor blueColor] size:CGSizeMake(size.width / 2.0, size.height / 2.0)];
        self.bottomLeftNode.anchorPoint = CGPointMake(0, 0);
        self.bottomLeftNode.position = CGPointMake(0, size.height / 2.0);
        
        self.bottomRightNode = [[NodeObject alloc] initWithColor:[UIColor yellowColor] size:CGSizeMake(size.width / 2.0, size.height / 2.0)];
        self.bottomRightNode.anchorPoint = CGPointMake(0, 0);
        self.bottomRightNode.position = CGPointMake(size.width / 2.0, size.height / 2.0);
        
        [self addChild:self.topLeftNode];
        [self addChild:self.topRightNode];
        [self addChild:self.bottomLeftNode];
        [self addChild:self.bottomRightNode];
    }
    return self;
}

//-(id)initWithColor:(UIColor *)color size:(CGSize)size
//{
//    if (self = [super initWithColor:color size:size]) {
//    }
//    return self;
//}

-(void)fireAction:(TPActionDescriptor *)actionDescriptor userInfo:(NSDictionary *)userInfo forActionType:(NSString *)actionType
{
    actionDescriptor.action(self, userInfo);
}

-(void)setupNodeWithColors:(NSArray *)colors
{
    if (colors && colors.count == 4) {
        self.topLeftNode.color = colors[0];
        self.topRightNode.color = colors[1];
        self.bottomLeftNode.color = colors[2];
        self.bottomRightNode.color = colors[3];
    }
}

-(void)resetNode {
    
}

@end
