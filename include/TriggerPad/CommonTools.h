//
//  CommonTools.h
//  BeeGame
//
//  Created by Ivan Borsa on 24/03/14.
//  Copyright (c) 2014 aayven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

static inline CGPoint rwAdd(CGPoint a, CGPoint b) {
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint rwSub(CGPoint a, CGPoint b) {
    return CGPointMake(a.x - b.x, a.y - b.y);
}

static inline CGPoint rwMult(CGPoint a, float b) {
    return CGPointMake(a.x * b, a.y * b);
}

static inline float rwLength(CGPoint a) {
    return sqrtf(a.x * a.x + a.y * a.y);
}

// Makes a vector have a length of 1
static inline CGPoint rwNormalize(CGPoint a) {
    float length = rwLength(a);
    if (length == 0.0) {
        length = FLT_MIN;
    }
    return CGPointMake(a.x / length, a.y / length);
}

@interface CommonTools : NSObject

+(int)getRandomNumberFromInt:(int)from toInt:(int)to;
+(float)getRandomFloatFromFloat:(float)from toFloat:(float)to;
+(UIColor *)stringToColor:(NSString *) colorString;
+(UIColor *)stringToColor:(NSString *) colorString withAlpha:(CGFloat)alpha;
+(UIColor *)getRandomColorCloseToColor:(UIColor *)sourceColor withDispersion:(CGFloat)dispersion;

@end
