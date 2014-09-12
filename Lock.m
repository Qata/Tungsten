//
//  Lock.m
//  serial_interface
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

- (void)lock
{
    pthread_mutex_lock(&mutex);
}

- (void)unlock
{
    pthread_mutex_unlock(&mutex);
}

- (uint8_t)tryLock
{
    return pthread_mutex_trylock(&mutex) == 0;
}
@end
