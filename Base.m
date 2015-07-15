#import <stdlib.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <assert.h>
#include <stdio.h>
#import "Base.h"
#import "AutoReleasePool.h"
#import <string.h>

@implementation Base

+ (id)alloc
{
	CTAllocatorRef zone = CTAllocatorCreate();
	id obj = CTAllocatorAllocate(zone, class_getInstanceSize(self));
	*(Class *)obj = self;
	[obj setZone:zone];
	return [obj retain];
}

+ (void)initialize
{
}

+ (void)load
{
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

+ (UInteger)hash
{
	return (UInteger)self;
}

- (UInteger)hash
{
	return (UInteger)self;
}

- (id)init
{
	return self;
}

+ (id)new
{
	return [[self alloc] init];
}

- (void)setZone:(CTAllocatorRef)alloc
{
	zone = alloc;
}

- (id)retain
{
	++retainCount;
	return self;
}

- (id)autorelease
{
	[AutoReleasePool addObject:self];
	return self;
}

- (void)release
{
	if (--retainCount <= 0)
	{
		[self dealloc];
	}
}

+ (uint8_t)isEqual:(id)object
{
	return object == (id)self;
}

- (uint8_t)isEqual:(id)object
{
    return object == self;
}

+ (uint8_t)isSubclassOfClass:(Class)class
{
    for (Class tcls = self; tcls; tcls = class_getSuperclass(tcls))
	{
        if (tcls == class) return 1;
    }
    return 0;
}

- (UInteger)retainCount
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

+ (uint8_t)isAncestorOfObject:(id)obj
{
    for (Class tcls = [obj class]; tcls; tcls = class_getSuperclass(tcls))
	{
        if (tcls == self) return 1;
    }
    return 0;
}

+ (uint8_t)respondsToSelector:(SEL)aSelector
{
	return aSelector != 0 && class_respondsToSelector(object_getClass((id)self), aSelector);
}

- (uint8_t)respondsToSelector:(SEL)aSelector
{
    return aSelector != 0 && class_respondsToSelector([self class], aSelector);
}

+ (IMP)methodForSelector:(SEL)aSelector
{
	assert(aSelector);
	if (![self respondsToSelector:aSelector])
	{
		[self doesNotRecognizeSelector:aSelector];
	}
	return method_getImplementation(class_getClassMethod(self, aSelector));
}

- (IMP)methodForSelector:(SEL)aSelector
{
	assert(aSelector);
	if (![self respondsToSelector:aSelector])
	{
		[self doesNotRecognizeSelector:aSelector];
	}
	return class_getMethodImplementation([self class], aSelector);
}

+ (id)performSelector:(SEL)aSelector
{
	return (*[self methodForSelector:aSelector])(self, aSelector);
}

- (id)performSelector:(SEL)aSelector
{
	return (*[self methodForSelector:aSelector])(self, aSelector);
}

+ (id)performSelector:(SEL)aSelector withObject:(id)obj
{
	return (*[self methodForSelector:aSelector])(self, aSelector, obj);
}

- (id)performSelector:(SEL)aSelector withObject:(id)obj
{
	return (*[self methodForSelector:aSelector])(self, aSelector, obj);
}

+ (id)performSelector:(SEL)aSelector withObject:(id)obj1 withObject:(id)obj2
{
	return (*[self methodForSelector:aSelector])(self, aSelector, obj1, obj2);
}

- (id)performSelector:(SEL)aSelector withObject:(id)obj1 withObject:(id)obj2
{
	return (*[self methodForSelector:aSelector])(self, aSelector, obj1, obj2);
}

+ (void)doesNotRecognizeSelector:(SEL)sel
{
	fprintf(stderr, "-[%s %s]: unrecognized selector sent to class\n", object_getClassName(self), sel_getName(sel));
	abort();
}

- (void)doesNotRecognizeSelector:(SEL)sel
{
    fprintf(stderr, "-[%s %s]: unrecognized selector sent to instance %p\n", object_getClassName(self), sel_getName(sel), self);
	abort();
}

@end
