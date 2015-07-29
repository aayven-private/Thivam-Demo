//
//  IBConnectionDescriptor.h
//  thivam
//
//  Created by Ivan Borsa on 23/09/14.
//  Copyright (c) 2014 ivanborsa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPConnectionDescriptor : NSObject

@property (nonatomic) NSString *connectionType;
@property (nonatomic) BOOL isAutoFired;
@property (nonatomic) NSDictionary *userInfo;
@property (nonatomic) float autoFireDelay;
@property (nonatomic) BOOL randomFireOrder;
@property (nonatomic) float autoFireDispersion;
@property (nonatomic) double connectionFireThreshold;
@property (nonatomic) BOOL ignoreActionId;
@property (nonatomic) NSNumber *nodeValue;
@property (nonatomic) NSMutableArray *connectionMap;
@property (nonatomic) BOOL isPipedConnection;

@end
