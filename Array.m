//
//  Array.m
//  serial_interface
//
//  Created by Carlo Tortorella on 4/09/2014.
//  Copyright (c) 2014 DALI Lighting. All rights reserved.
//

#import "Array.h"
#import <stdarg.h>
#import <stdlib.h>
#import <string.h>
#import <assert.h>

@implementation Array

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
			count = cnt;
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
	for (UInteger i = 0; i < count; ++i)
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
	return count;
}

- (UInteger)indexOfObject:(id)object
{
	for (UInteger i = 0; i < count; ++ i)
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
	array = CTAllocatorReallocate(zone, array, (count + 1) * sizeof(id));
	[object retain];
	array[count++] = object;
}

- (void)removeObject:(id)object
{
	UInteger index;
	if ((index = [self indexOfObject:object]) != NotFound)
	{
		[array[index] release];
		--count;
		memmove((array + index), (array + index + 1), (count - index) * sizeof(id));
		array = CTAllocatorReallocate(zone, array, count * sizeof(id));
	}
}

- (void)removeObjectAtIndex:(UInteger)index
{
	assert(index < count);
	[array[index] release];
	--count;
	memmove((array + index), (array + index + 1), (count - index) * sizeof(id));
	array = CTAllocatorReallocate(zone, array, count * sizeof(id));
}

- (void)removeAllObjects
{
	for (UInteger i = 0; i < count; ++i)
	{
		[array[i] release];
	}
	count = 0;
}

- (id)objectAtIndex:(UInteger)index
{
	assert(index < count);
	return array[index];
}

- (id)firstObject
{
	return count ? array[0] : nil;
}

- (id)lastObject
{
	return count ? array[count - 1] : nil;
}

- (void)map:(SEL)sel
{
	for (UInteger i = 0; i < count; ++ i)
	{
		[array[i] performSelector:sel];
	}
}

@end
