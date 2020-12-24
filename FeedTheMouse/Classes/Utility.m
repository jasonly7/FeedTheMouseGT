//
//  Utility.m
//  FeedTheMouse
//
//  Created by Jason Ly on 2020-12-24.
//  Copyright © 2020 Jason Ly. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (BOOL) isNumeric:(NSString*) value {

    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:value];

    BOOL valid = [alphaNums isSupersetOfSet:inStringSet];

    alphaNums = nil;
    inStringSet = nil;

    return valid;
}
@end
