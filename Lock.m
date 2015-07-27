//
//  Lock.m
//  Firestarter
//
//  Created by Carlo Tortorella on 29/08/2014.
//  Copyright (c) 2014 DALI Lighting. All rights reserved.
//

#import "Lock.h"

@implementation Lock

- (id)init
{
    if (self = [super init])
    {
        pthread_mutex_init(&mutex, NULL);
    }
    return self;
} 

- (void)dealloc
{
    pthread_mutex_destroy(&mutex);
    [super dealloc];
}

- (int)lock
{
	return pthread_mutex_lock(&mutex);
}

- (int)unlock
{
    return pthread_mutex_unlock(&mutex);
}

- (int)tryLock
{
    return pthread_mutex_trylock(&mutex);
}
@end
