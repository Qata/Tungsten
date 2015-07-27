//
//  Array.h
//  Firestarter
//
//  Created by Carlo Tortorella on 4/09/2014.
//  Copyright (c) 2014 DALI Lighting. All rights reserved.
//

#import "Base.h"

@interface Array : Base
{
	id * array;
	UInteger _count;
}
- (id)initWithObjects:(id)object, ...;
- (id)initWithObjects:(const id[])objects count:(UInteger)count;
- (void)addObject:(id)object;
- (id *)contents;
- (UInteger)indexOfObject:(id)object;
- (void)removeObject:(id)object;
- (void)removeObjectAtIndex:(UInteger)index;
- (void)removeAllObjects;
- (id)objectAtIndex:(UInteger)index;
- (id)firstObject;
- (id)lastObject;
- (void)map:(SEL)sel;
@property (nonatomic, assign, readonly) UInteger count;
@end