//
//  SceneEntity.h
//  ap-effects
//
//  Created by Ivan Borsa on 23/02/15.
//  Copyright (c) 2015 ivanborsa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SceneEntity : NSManagedObject

@property (nonatomic, retain) NSString * sceneId;
@property (nonatomic, retain) NSString * sceneName;
@property (nonatomic, retain) NSString * storyId;

@end
