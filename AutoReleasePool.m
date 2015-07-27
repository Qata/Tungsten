//
//  AutoReleasePool.m
//  Firestarter
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

+ (UInteger)indexOfCurrentThread
{
	UInteger index = NotFound;
	for (UInteger i = 0; i < pool_loc; ++i)
	{
		if (pthread_equal(pool_keys[i], pthread_self()))
		{
			index = i;
			break;
		}
	}
	return index;
}

+ (void)removeThreadPool
{
	UInteger index;
	if ((index = [self indexOfCurrentThread]) != NotFound)
	{
		[pool_values removeObjectAtIndex:index];
		memmove(pool_keys + index, pool_keys + index + 1, (pool_loc-- - index) * sizeof(pthread_t *));
	}
}

- (id)init
{
	if (self = [super init])
	{
		objects = [Array new];
		[pool_lock lock];
		if ([AutoReleasePool indexOfCurrentThread] == NotFound)
		{
			if (pool_loc >= pool_size / sizeof(pthread_t *))
			{
				pool_size = (pool_loc + 1) * sizeof(pthread_t *) * kArrayGrowthFactor;
				pool_keys = CTAllocatorReallocate(zone, pool_keys, sizeof(pthread_t *) * pool_size);
			}
			pool_keys[pool_loc++] = pthread_self();
			Array * newPool = [Array new];
			[pool_values addObject:newPool];
			[newPool release];
		}
		[[pool_values objectAtIndex:[AutoReleasePool indexOfCurrentThread]] addObject:self];
		[pool_lock unlock];
	}
	return self;
}

- (void)dealloc
{
	retainCount = 2;
	[pool_lock lock];
	Array * threadPool = [pool_values objectAtIndex:[AutoReleasePool indexOfCurrentThread]];
	[threadPool removeObject:self];
	if (![threadPool count])
	{
		[AutoReleasePool removeThreadPool];
	}
	[objects map:@selector(release)];
	[objects release];
	[pool_lock unlock];
	[super dealloc];
}

- (void)drain
{
	[self dealloc];
}

- (void)addObject:(id)object
{
	[objects addObject:object];
}

+ (void)addObject:(id)object
{
	[pool_lock lock];
	UInteger index = NotFound;
	if ((index = [self indexOfCurrentThread]) != NotFound)
	{
		//Add the object to the last pool in the stack
		[[[pool_values objectAtIndex:index] lastObject] addObject:object];
	}
	else
	{
		fprintf(stderr, "No autoreleasepool present for thread %p, aborting\n", (void *)pthread_self());
		abort();
	}
	[pool_lock unlock];
}
@end
