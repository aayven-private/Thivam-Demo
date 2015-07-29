//
//  GestureEntity.h
//  ap-effects
//
//  Created by Ivan Borsa on 23/02/15.
//  Copyright (c) 2015 ivanborsa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GestureEntity : NSManagedObject

@property (nonatomic, retain) NSString * gestureId;
@property (nonatomic, retain) NSString * effectName;
@property (nonatomic, retain) NSString * triggerPoints;
@property (nonatomic, retain) NSData * gestureColor;
@property (nonatomic, retain) NSNumber * involvedNodeCount;
@property (nonatomic, retain) NSString * startPoint;
@property (nonatomic, retain) NSString * sceneId;
@property (nonatomic, retain) NSNumber * randomizeColor;
@property (nonatomic, retain) NSNumber * isDisappearing;

@end
