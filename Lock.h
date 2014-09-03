//
//  Lock.h
//  serial_interface
//
//  Created by Carlo Tortorella on 29/08/2014.
//  Copyright (c) 2014 DALI Lighting. All rights reserved.
//

#import "Base.h"
#import <pthread.h>

@interface Lock : Base
{
    pthread_mutex_t mutex;
}
- (void)lock;
- (void)unlock;
- (uint8_t)tryLock;
@end
