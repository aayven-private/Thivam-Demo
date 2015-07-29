//
//  StoryEntity.h
//  ap-effects
//
//  Created by Ivan Borsa on 25/02/15.
//  Copyright (c) 2015 ivanborsa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StoryEntity : NSManagedObject

@property (nonatomic, retain) NSString * storyId;
@property (nonatomic, retain) NSString * storyName;

@end
