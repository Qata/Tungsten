//
//  MutableString.h
//  serial_interface
//
//  Created by Carlo Tortorella on 29/08/2014.
//  Copyright (c) 2014 DALI Lighting. All rights reserved.
//

#import "String.h"

@interface MutableString : String
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
