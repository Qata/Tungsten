//
//  MutableString.m
//  serial_interface
//
//  Created by Carlo Tortorella on 29/08/2014.
//  Copyright (c) 2014 DALI Lighting. All rights reserved.
//

#import "MutableString.h"

@implementation MutableString

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
    CTStringAppendCharacters(string, str->string->characters, CTSTRING_NO_LIMIT);
}

- (void)prependString:(String *)str
{
    CTStringPrependCharacters(string, str->string->characters, CTSTRING_NO_LIMIT);
}

@end
