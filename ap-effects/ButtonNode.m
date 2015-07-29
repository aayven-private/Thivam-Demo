//
//  ButtonNode.m
//  ap-effects
//
//  Created by Ivan Borsa on 21/02/15.
//  Copyright (c) 2015 ivanborsa. All rights reserved.
//

#import "ButtonNode.h"

@interface ButtonNode()

@property (nonatomic) SKLabelNode *textLabel;

@end

@implementation ButtonNode

-(id)initWithColor:(UIColor *)color size:(CGSize)size delegate:(id<ButtonDelegate>)delegate
{
    if (self = [super initWithColor:color size:size]) {
        self.buttonDelegate = delegate;
        self.userInteractionEnabled = YES;
        self.textLabel = [SKLabelNode labelNodeWithFontNamed:@"Copperplate-Bold"];
        self.textLabel.position = CGPointMake(0, 0);
        self.textLabel.fontColor = [UIColor blackColor];
        self.textLabel.fontSize = 15;
        self.textLabel.text = @"P";
        self.textLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        [self addChild:self.textLabel];
        self.userInfo = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)setText:(NSString *)text
{
    _textLabel.text = text;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_buttonDelegate buttonClicked:self];
}

@end
