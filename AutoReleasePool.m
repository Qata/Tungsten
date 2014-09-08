//
//  AutoReleasePool.m
//  serial_interface
//
//  Created by Carlo Tortorella on 4/09/2014.
//  Copyright (c) 2014 DALI Lighting. All rights reserved.
//

#import "AutoReleasePool.h"
#import "Dictionary.h"
#include <semaphore.h>

static Dictionary * pools;
static sem_t poolLock;

@implementation AutoReleasePool

+ (void)initialize
{
	if ([self class] == [AutoReleasePool class])
	{
		pools = [Dictionary new];
		sem_init(&poolLock, 0, 1);
	}
}

- (id)init
{
	if (self = [super init])
	{
		
	}
	return self;
}

+ (void)addObject:(id)object
{
	
}
@end
