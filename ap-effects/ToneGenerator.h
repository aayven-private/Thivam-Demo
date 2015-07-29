//
//  ToneGenerator.h
//  ap-effects
//
//  Created by Ivan Borsa on 12/02/15.
//  Copyright (c) 2015 ivanborsa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface ToneGenerator : NSObject
{    
@public
    double frequency;
    double sampleRate;
    double theta;
}

-(AudioComponentInstance)generateToneForColumn:(int)columnIndex andRow:(int)rowIndex;

@end
