//
//  String.h
//  serial_interface
//
//  Created by Carlo Tortorella on 29/08/2014.
//  Copyright (c) 2014 DALI Lighting. All rights reserved.
//

#import <CTObject/CTString.h>
#import "Base.h"

#ifdef __objc_INCLUDE_GNU
#import <objc/NXConstStr.h>
@interface NXConstantString (UTF8String)
- (const char *)UTF8String;
- (UInteger)hash;
@end
#endif

@interface String : Base
{
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
- (void)setCharacters:(const char *)characters;
- (void)appendCharacters:(const char *)characters;
- (void)appendCharacter:(char)character;
- (void)prependCharacters:(const char *)characters;
- (void)prependCharacter:(char)character;
- (void)removeCharactersFromBeginning:(uint64_t)count;
- (void)removeCharactersFromEnd:(uint64_t)count;
- (void)appendString:(String *)string;
- (void)prependString:(String *)string;
@end