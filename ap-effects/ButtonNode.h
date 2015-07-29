//
//  ButtonNode.h
//  ap-effects
//
//  Created by Ivan Borsa on 21/02/15.
//  Copyright (c) 2015 ivanborsa. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ButtonDelegate.h"

@interface ButtonNode : SKSpriteNode

-(id)initWithColor:(UIColor *)color size:(CGSize)size delegate:(id<ButtonDelegate>)delegate;

@property (nonatomic, weak) id<ButtonDelegate> buttonDelegate;

@property (nonatomic) NSString *text;
@property (nonatomic) NSMutableDictionary *userInfo;

@end
