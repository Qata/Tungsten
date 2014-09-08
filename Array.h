//
//  Array.h
//  serial_interface
//
//  Created by Carlo Tortorella on 4/09/2014.
//  Copyright (c) 2014 DALI Lighting. All rights reserved.
//

#import "Base.h"

@interface Array : Base
{
	id * array;
	UInteger count;
}
- (id)initWithObjects:(id)object, ...;
- (id)initWithObjects:(const id[])objects count:(UInteger)count;
- (void)addObject:(id)object;
- (UInteger)count;
- (id *)contents;
- (UInteger)indexOfObject:(id)object;
- (void)removeObject:(id)object;
- (void)removeAllObjects;
- (id)objectAtIndex:(UInteger)index;
- (id)firstObject;
- (id)lastObject;
@end