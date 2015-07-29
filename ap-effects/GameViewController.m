//
//  GameViewController.m
//  ap-effects
//
//  Created by Ivan Borsa on 08/01/15.
//  Copyright (c) 2015 ivanborsa. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@interface GameViewController()

@property (nonatomic) GameScene *gameScene;
@property (nonatomic) UIColor *currentColor;

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

-(void)viewWillLayoutSubviews
{
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    if (!skView.scene) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *penColor_data = [defaults objectForKey:@"pen_color"];
        UIColor *penColor;
        if (!penColor_data) {
            penColor = [UIColor redColor];
        } else {
            penColor = [NSKeyedUnarchiver unarchiveObjectWithData:penColor_data];
        }
        
        // Create and configure the scene.
        _gameScene = [GameScene sceneWithSize:skView.bounds.size];
        _gameScene.scaleMode = SKSceneScaleModeAspectFill;
        _gameScene.sceneDelegate = self;
        _gameScene.penColor = penColor;

        // Present the scene.
        [skView presentScene:_gameScene];
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)showViewController:(UIViewController *)viewController
{
    [self presentViewController:viewController animated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    
    // Dismiss the image selection, hide the picker and
    
    //show the image view with the picked image
    
    [picker dismissModalViewControllerAnimated:YES];
    //UIImage *newImage = image;
    NSLog(@"Image size: %@", NSStringFromCGSize(image.size));
    //[_gameScene imagePicked:image];
}

-(void)colorPickerClickedWithRandomize:(BOOL)randomize andDisappear:(BOOL)disappear
{
    NEOColorPickerViewController *controller = [[NEOColorPickerViewController alloc] init];
    controller.delegate = self;
    controller.randomizeColor = randomize;
    controller.disappear = disappear;
    controller.selectedColor = self.currentColor;
    controller.title = @"Pen color";
    UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)colorPickerViewController:(NEOColorPickerBaseViewController *)controller didSelectColor:(UIColor *)color withRandomize:(BOOL)randomize withDisappear:(BOOL)disappear {
    //self.view.backgroundColor = color;
    _currentColor = color;
    [_gameScene colorPicked:color withRandomize:randomize withDisappear:disappear];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
    
    [defaults setObject:colorData forKey:@"pen_color"];
    [defaults synchronize];
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)colorPickerViewControllerDidCancel:(NEOColorPickerBaseViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)backClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
