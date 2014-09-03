#include <stdlib.h>
#include <objc/runtime.h>
#include <assert.h>
#import "Base.h"

@implementation Base

+ (id)alloc
{
	CTAllocator * zone = CTAllocatorCreate();
	id obj = CTAllocatorAllocate(zone, class_getInstanceSize(self));
	*(Class *)obj = self;
	[obj setZone:zone];
	return [obj retain];
}

- (void)dealloc
{
	CTAllocatorRelease(zone);
}

+ (Class)class
{
	return self;
}

- (Class)class
{
	return object_getClass(self);
}

+ (Class)superclass
{
    return class_getSuperclass(self);
}

- (Class)superclass
{
    return class_getSuperclass([self class]);
}

- (id)init
{
	return self;
}

+ (id)new
{
	return [[self alloc] init];
}

- (void)setZone:(CTAllocator *)alloc
{
	zone = alloc;
}

- (id)retain
{
	++retainCount;
	return self;
}

- (void)release
{
	if (--retainCount <= 0)
	{
		[self dealloc];
	}
}

- (uint8_t)isEqual:(id)object
{
    if (object)
    {
        if ([self class] == [object class])
        {
            return 1;
        }
    }
    return 0;
}

+ (uint8_t)isSubclassOfClass:(Class)class
{
    Class scls = class_getSuperclass(self);
    while (scls != class_getSuperclass(scls))
    {
        if (scls == class)
        {
            return 1;
        }
        scls = class_getSuperclass(scls);
    }
    return 0;
}

- (uint64_t)retainCount
{
    return retainCount;
}

+ (uint8_t)isKindOfClass:(Class)class
{
    return [self isMemberOfClass:class] || [self isSubclassOfClass:class];
}

+ (uint8_t)isMemberOfClass:(Class)class
{
    return [self class] == class;
}

- (uint8_t)isSubclassOfClass:(Class)class
{
    return [[self class] isSubclassOfClass:class];
}

- (uint8_t)isKindOfClass:(Class)class
{
    return [[self class] isKindOfClass:class];
}

- (uint8_t)isMemberOfClass:(Class)class
{
    return [[self class] isMemberOfClass:class];
}

- (uint8_t)respondsToSelector:(SEL)aSelector
{
    assert(aSelector);
    Class cls = object_getClass(self);
    if (class_respondsToSelector(cls, aSelector))
    {
        return 1;
    }
    return 0;
}

@end
