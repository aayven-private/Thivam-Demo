//
//  GameScene.h
//  ap-effects
//

//  Copyright (c) 2015 ivanborsa. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameSceneDelegate.h"
#import "ButtonDelegate.h"

@interface GameScene : SKScene

@property (nonatomic, weak) id<GameSceneDelegate> sceneDelegate;
@property (nonatomic) UIColor *penColor;

-(void)initScene;
-(void)colorPicked:(UIColor *)color withRandomize:(BOOL)randomize withDisappear:(BOOL)disappear;

@end
