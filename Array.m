//
//  Array.m
//  Firestarter
//
//  Created by Carlo Tortorella on 4/09/2014.
//  Copyright (c) 2014 DALI Lighting. All rights reserved.
//

#import "Array.h"
#import <stdarg.h>
#import <stdlib.h>
#import <string.h>
#import <assert.h>
#import <math.h>

@implementation Array

@synthesize count = _count;

- (id)initWithObjects:(id)object, ...
{
	if (self = [super init])
	{
		va_list list;
		va_start(list, object);
		do
		{
			[self addObject:object];
			object = va_arg(list, id);
		} while (object != nil);
		va_end(list);
	}
	return self;
}

- (id)initWithObjects:(const id[])objects count:(UInteger)cnt
{
	if (self = [super init])
	{
		if (cnt)
		{
			array = CTAllocatorReallocate(zone, array, cnt * sizeof(id));
			for (UInteger i = 0; i < cnt; ++i)
			{
				[objects[i] retain];
				array[i] = objects[i];
			}
			_count = cnt;
		}
	}
	return self;
}

- (void)dealloc
{
	[self removeAllObjects];
	[super dealloc];
}

- (UInteger)hash
{
	UInteger ret = 0;
	for (UInteger i = 0; i < self.count; ++i)
	{
		ret += [[self objectAtIndex:i] hash];
	}
	return ret;
}

- (id *)contents
{
	return array;
}

- (UInteger)count
{
	return _count;
}

- (UInteger)indexOfObject:(id)object
{
	for (UInteger i = 0; i < self.count; ++ i)
	{
		if ([array[i] isEqual:object])
		{
			return i;
		}
	}
	return NotFound;
}

- (void)addObject:(id)object
{
	array = CTAllocatorReallocate(zone, array, (self.count + 1) * sizeof(id));
	[object retain];
	array[_count++] = object;
}

- (void)removeObject:(id)object
{
	UInteger index;
	if ((index = [self indexOfObject:object]) != NotFound)
	{
		[array[index] release];
		--_count;
		memmove((array + index), (array + index + 1), (self.count - index) * sizeof(id));
		array = CTAllocatorReallocate(zone, array, self.count * sizeof(id));
	}
}

- (void)removeObjectAtIndex:(UInteger)index
{
	assert(index < self.count);
	[array[index] release];
	--_count;
	memmove((array + index), (array + index + 1), (self.count - index) * sizeof(id));
	array = CTAllocatorReallocate(zone, array, self.count * sizeof(id));
}

- (void)removeAllObjects
{
	for (UInteger i = 0; i < self.count; ++i)
	{
		[array[i] release];
	}
	_count = 0;
}

- (id)objectAtIndex:(UInteger)index
{
	assert(index < self.count);
	return array[index];
}

- (id)firstObject
{
	return self.count ? array[0] : nil;
}

- (id)lastObject
{
	return self.count ? array[self.count - 1] : nil;
}

- (void)map:(SEL)sel
{
	for (UInteger i = 0; i < self.count; ++ i)
	{
		[array[i] performSelector:sel];
	}
}

- (void)each:(void(^)(id))block
{
	for (UInteger i = 0; i < self.count; ++ i)
	{
		block(array[i]);
	}
}

- (void)filter:(uint8_t(^)(id object))filter_block each:(void(^)(id object))each_block
{
	for (UInteger i = 0; i < self.count; ++ i)
	{
		if (filter_block(array[i]))
		{
			each_block(array[i]);
		}
	}
}

- (void)filterClass:(Class)class each:(void(^)(id object))each_block
{
	[self filter:^uint8_t(id object) {
		return [object isKindOfClass:class];
	} each:each_block];
}

- (uint8_t)any:(uint8_t(^)(id object))block
{
	for (UInteger i = 0; i < self.count; ++i)
	{
		if (block(array[i]))
		{
			return 1;
		}
	}
	return 0;
}

- (uint8_t)all:(uint8_t(^)(id object))block
{
	for (UInteger i = 0; i < self.count; ++i)
	{
		if (!block(array[i]))
		{
			return 0;
		}
	}
	return 1;
}

@end
