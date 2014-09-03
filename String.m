//
//  String.m
//  serial_interface
//
//  Created by Carlo Tortorella on 29/08/2014.
//  Copyright (c) 2014 DALI Lighting. All rights reserved.
//

#import "String.h"

#ifndef __MACH__
#import <objc/NXConstStr.h>
@implementation NXConstantString (UTF8String)
- (const char *)UTF8String
{
    return [self cString];
}
@end
#endif

@implementation String

+ (id)stringWithCharacters:(const char *)characters length:(unsigned int)length
{
    return [[self alloc] initWithUTF8String:characters];
}

+ (id)stringWithCString:(const char*)byteString
{
    return [[self alloc] initWithUTF8String:byteString];
}

+ (id)stringWithCString:(const char*)byteString length:(unsigned int)length
{
    return [[self alloc] initWithUTF8String:byteString];
}

+ (id)stringWithUTF8String:(const char *)characters
{
    return [[self alloc] initWithUTF8String:characters];
}

- (id)initWithUTF8String:(const char *)characters
{
    if (self = [super init])
    {
        string = CTStringCreate(zone, characters);
    }
    return self;
}

- (uint64_t)length
{
    return CTStringLength(string);
}

- (const char *)UTF8String
{
    return string->characters;
}

- (const char *)cString
{
    return [self UTF8String];
}

- (uint8_t)containsString:(String *)str
{
    return CTStringContainsString(string, str->string->characters);
}

- (uint8_t)isEqual:(id)object
{
    if ([super isEqual:object])
    {
        return [self isEqualToString:object];
    }
    return 0;
}

- (uint8_t)isEqualToString:(String *)object
{
    return CTStringCompare(string, object->string) == 0;
}

@end
