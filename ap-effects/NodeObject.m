//
//  NodeObject.m
//  ap-effects
//
//  Created by Ivan Borsa on 08/01/15.
//  Copyright (c) 2015 ivanborsa. All rights reserved.
//

#import "NodeObject.h"

@implementation NodeObject

-(id)initWithColor:(UIColor *)color size:(CGSize)size
{
    if (self = [super initWithColor:color size:size]) {
        //self.gestureIds = [NSMutableArray array];
    }
    return self;
}

-(void)fireAction:(TPActionDescriptor *)actionDescriptor userInfo:(NSDictionary *)userInfo forActionType:(NSString *)actionType
{
    actionDescriptor.action(self, userInfo);
}

@end
