//
//  AutoReleasePool.m
//  serial_interface
//
//  Created by Carlo Tortorella on 4/09/2014.
//  Copyright (c) 2014 DALI Lighting. All rights reserved.
//

#import "AutoReleasePool.h"
#import "Array.h"
#import "Lock.h"
#include <pthread.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

UInteger pool_size = 0;
UInteger pool_loc = 0;
pthread_t * pool_keys = NULL;
Array * pool_values = NULL;
Lock * pool_lock;

@implementation AutoReleasePool

+ (void)initialize
{
	if ([self class] == [AutoReleasePool class])
	{
		pool_values = [Array new];
		pool_lock = [Lock new];
	}
}

+ (UInteger)indexOfKey:(pthread_t)key
{
	UInteger index = NotFound;
	for (UInteger i = 0; i < pool_loc; ++i)
	{
		if (pthread_equal(pool_keys[i], key))
		{
			index = i;
			break;
		}
	}
	return index;
}

+ (void)removeThreadPool
{
	UInteger index = NotFound;
	if ((index = [self indexOfKey:pthread_self()]) != NotFound)
	{
		Array * pools = [pool_values objectAtIndex:[self indexOfKey:pthread_self()]];
		if (![pools count])
		{
			[pool_values removeObject:pools];
			memmove(pool_keys + index, pool_keys + index + 1, pool_loc - index);
			--pool_loc;
		}
	}
}

- (id)init
{
	if (self = [super init])
	{
		[pool_lock lock];
		objects = [Array new];
		puts("Creating pool");
		if ([AutoReleasePool indexOfKey:pthread_self()] == NotFound)
		{
			puts("Adding thread");
			printf("%llu\n", [pool_values count]);
			if (pool_loc >= pool_size)
			{
				pool_size = (pool_loc + 1) * 1.3;
				pool_keys = CTAllocatorReallocate(CTAllocatorGetDefault(), pool_keys, sizeof(pthread_t) * pool_size);
			}
			pool_keys[pool_loc] = pthread_self();
			[pool_values addObject:[Array new]];
			[[pool_values lastObject] release];
			++pool_loc;
		}
		printf("%p\n", [pool_values objectAtIndex:[AutoReleasePool indexOfKey:pthread_self()]]);
		[[pool_values objectAtIndex:[AutoReleasePool indexOfKey:pthread_self()]] addObject:self];
		[pool_lock unlock];
	}
	return self;
}

- (void)dealloc
{
	[self retain];
	[self retain];
	Array * threadPool = [pool_values objectAtIndex:[AutoReleasePool indexOfKey:pthread_self()]];
	[threadPool removeObject:self];
	[AutoReleasePool removeThreadPool];
	[objects map:@selector(release)];
	[objects release];
	[super dealloc];
}

- (void)drain
{
	--retainCount;
	[self release];
}

- (void)addObject:(id)object
{
	[objects addObject:object];
}

+ (void)addObject:(id)object
{
	UInteger index = NotFound;
	if ((index = [self indexOfKey:pthread_self()]) != NotFound)
	{
		Array * array = [pool_values objectAtIndex:index];
		AutoReleasePool * pool = [array objectAtIndex:[array count] - 1];
		[pool addObject:object];
	}
	else
	{
		fputs("No autoreleasepool present, aborting\n", stderr);
		abort();
	}
}
@end
