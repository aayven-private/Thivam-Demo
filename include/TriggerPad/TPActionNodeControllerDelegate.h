//
//  IBActionNodeControllerDelegate.h
//  thivam
//
//  Created by Ivan Borsa on 24/09/14.
//  Copyright (c) 2014 ivanborsa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TPActionDescriptor.h"

@protocol TPActionNodeControllerDelegate <NSObject>

-(NSArray *)getUnifiedActionDescriptorsForActionType:(NSString *)actionType;
-(BOOL)isActionIdCancelled:(NSString *)actionId;

@end
