//
//  SceneListControllerDelegate.h
//  ap-effects
//
//  Created by Ivan Borsa on 23/02/15.
//  Copyright (c) 2015 ivanborsa. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SceneListControllerDelegate <NSObject>

-(void)storySelectedWithId:(NSString *)sceneId;

@end
