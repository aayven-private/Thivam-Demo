//
//  GameSceneDelegate.h
//  ap-effects
//
//  Created by Ivan Borsa on 13/02/15.
//  Copyright (c) 2015 ivanborsa. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GameSceneDelegate <NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

-(void)showViewController:(UIViewController *)viewController;
-(void)colorPickerClickedWithRandomize:(BOOL)randomize andDisappear:(BOOL)disappear;
-(void)backClicked;

@end
