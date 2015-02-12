//
//  String.m
//  serial_interface
//
//  Created by Carlo Tortorella on 29/08/2014.
//  Copyright (c) 2014 DALI Lighting. All rights reserved.
//

#import "String.h"

#ifdef __objc_INCLUDE_GNU
#import <objc/NXConstStr.h>
@implementation NXConstantString (UTF8String)
- (const char *)UTF8String
{
    return [self cString];
}

- (UInteger)hash
{
	UInteger ret = 0;
	for(UInteger count = 0; count < [self length]; ++count)
	{
		ret += (ret << 5) + [self cString][count];
	}
	return ret;
}
@end
#endif

@implementation String

+ (id)stringWithCharacters:(const char *)characters length:(unsigned int)length
{
	if (length)
	{
		return [[[self alloc] initWithUTF8String:characters] autorelease];
	}
	return [[self new] autorelease];
}

+ (id)stringWithCString:(const char*)byteString
{
	return [[[self alloc] initWithUTF8String:byteString] autorelease];
}

+ (id)stringWithCString:(const char *)byteString length:(unsigned int)length
{
	if (length)
	{
		return [[[self alloc] initWithUTF8String:byteString] autorelease];
	}
	return [[self new] autorelease];
}

+ (id)stringWithUTF8String:(const char *)characters
{
    return [[[self alloc] initWithUTF8String:characters] autorelease];
}

- (id)initWithUTF8String:(const char *)characters
{
    if (self = [super init])
    {
        string = CTStringCreate(zone, characters);
    }
    return self;
}

- (UInteger)hash
{
	return CTStringHash(string);
}

- (uint64_t)length
{
    return CTStringLength(string);
}

- (const char *)UTF8String
{
    return CTStringUTF8String(string);
}

- (const char *)cString
{
    return CTStringUTF8String(string);
}

- (uint8_t)containsString:(String *)str
{
    return CTStringContainsString(string, [str UTF8String]);
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
    return CTStringCompare2(string, [object UTF8String]) == 0;
}
- (void)setCharacters:(const char *)characters
{
    CTStringSet(string, characters);
}

- (void)appendCharacters:(const char *)characters
{
    CTStringAppendCharacters(string, characters, CTSTRING_NO_LIMIT);
}

- (void)appendCharacter:(char)character
{
    CTStringAppendCharacter(string, character);
}

- (void)prependCharacters:(const char *)characters
{
    CTStringPrependCharacters(string, characters, CTSTRING_NO_LIMIT);
}

- (void)prependCharacter:(char)character
{
    CTStringPrependCharacter(string, character);
}

- (void)removeCharactersFromBeginning:(uint64_t)count
{
    CTStringRemoveCharactersFromStart(string, count);
}

- (void)removeCharactersFromEnd:(uint64_t)count
{
    CTStringRemoveCharactersFromEnd(string, count);
}

- (void)appendString:(String *)str
{
    CTStringAppendCharacters(string, [str UTF8String], CTSTRING_NO_LIMIT);
}

- (void)prependString:(String *)str
{
    CTStringPrependCharacters(string, [str UTF8String], CTSTRING_NO_LIMIT);
}

@end
