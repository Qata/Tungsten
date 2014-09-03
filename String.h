//
//  String.h
//  serial_interface
//
//  Created by Carlo Tortorella on 29/08/2014.
//  Copyright (c) 2014 DALI Lighting. All rights reserved.
//

#import <CTObject/CTString.h>
#import "Base.h"

#ifndef __MACH__
#import <objc/NXConstStr.h>
@interface NXConstantString (UTF8String)
- (const char *)UTF8String;
@end
#endif

@interface String : Base
{
@public
    CTString * string;
}
+ (id)stringWithCharacters:(const char *)characters length:(unsigned int)length;
+ (id)stringWithCString:(const char*)byteString;
+ (id)stringWithCString:(const char*)byteString length:(unsigned int)length;
+ (id)stringWithUTF8String:(const char *)characters;
- (id)initWithUTF8String:(const char *)characters;
- (uint64_t)length;
- (const char *)UTF8String;
- (uint8_t)containsString:(String *)string;
- (uint8_t)isEqualToString:(String *)string;
@end