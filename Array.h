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
- (void)each:(void(^)(id object))block;
- (void)filter:(uint8_t(^)(id object))filter_block each:(void(^)(id object))each_block;
- (void)filterClass:(Class)class each:(void(^)(id object))each_block;
- (uint8_t)any:(uint8_t(^)(id object))block;
- (uint8_t)all:(uint8_t(^)(id object))block;
@property (nonatomic, assign, readonly) UInteger count;
@end