//
//  IBActionDescriptor.h
//  thivam
//
//  Created by Ivan Borsa on 23/09/14.
//  Copyright (c) 2014 ivanborsa. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TPActionNodeActor;

typedef void(^nodeAction)(id<TPActionNodeActor>target, NSDictionary *userInfo);

@interface TPActionDescriptor : NSObject

@property (copy) nodeAction action;
@property (copy) nodeAction lastNodeAction;
@property (copy) nodeAction blockingNodeAction;
@property (copy) nodeAction blockedNodeAction;
@property (nonatomic) NSDictionary *userInfo;

//Just for info
@property (nonatomic) NSString *actionName;

@end