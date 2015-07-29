//
//  TPActionNodeActor.h
//  thivam
//
//  Created by Ivan Borsa on 23/09/14.
//  Copyright (c) 2014 ivanborsa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPActionDescriptor.h"

@protocol TPActionNodeActor <NSObject>

-(void)fireAction:(TPActionDescriptor *)actionDescriptor userInfo:(NSDictionary *)userInfo forActionType:(NSString *)actionType;
-(void)resetNode;

@end
