//
//  GameViewController.h
//  ap-effects
//

//  Copyright (c) 2015 ivanborsa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "GameSceneDelegate.h"
#import "NEOColorPickerViewController.h"

@interface GameViewController : UIViewController <GameSceneDelegate, NEOColorPickerViewControllerDelegate>

@property (nonatomic) NSString *sceneName;

@end
