//
//  AutoReleasePool.h
//  serial_interface
//
//  Created by Carlo Tortorella on 4/09/2014.
//  Copyright (c) 2014 DALI Lighting. All rights reserved.
//

#pragma once
#import "Base.h"
#import "Array.h"

@interface AutoReleasePool : Base
{
	Array * objects;
}
+ (void)addObject:(id)object;
@end
