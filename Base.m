#import <stdlib.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <assert.h>
#include <stdio.h>
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

+ (void)initialize
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
	UInteger hash = (UInteger)self;
	return hash;
}

- (UInteger)hash
{
	UInteger hash = (UInteger)self;
	return hash;
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

+ (id)performSelector:(SEL)aSelector
{
    assert(aSelector);
	if (![self respondsToSelector:aSelector])
	{
		[self doesNotRecognizeSelector:aSelector];
	}
	return (*method_getImplementation(class_getClassMethod(self, aSelector)))(self, aSelector);
}

- (id)performSelector:(SEL)aSelector
{
	assert(aSelector);
	if (![self respondsToSelector:aSelector])
	{
		[self doesNotRecognizeSelector:aSelector];
	}
	return (*class_getMethodImplementation([self class], aSelector))(self, aSelector);
}

- (id)performSelector:(SEL)aSelector withObject:(id)obj
{
	assert(aSelector);
	if (![self respondsToSelector:aSelector])
	{
		[self doesNotRecognizeSelector:aSelector];
	}
	return (*class_getMethodImplementation([self class], aSelector))(self, aSelector, obj);
}

+ (id)performSelector:(SEL)aSelector withObject:(id)obj
{
    assert(aSelector);
	if (![self respondsToSelector:aSelector])
	{
		[self doesNotRecognizeSelector:aSelector];
	}
	return (*method_getImplementation(class_getClassMethod(self, aSelector)))(self, aSelector, obj);
}

- (id)performSelector:(SEL)aSelector withObject:(id)obj1 withObject:(id)obj2
{
	assert(aSelector);
	if (![self respondsToSelector:aSelector])
	{
		[self doesNotRecognizeSelector:aSelector];
	}
	return (*class_getMethodImplementation([self class], aSelector))(self, aSelector, obj1, obj2);
}

+ (id)performSelector:(SEL)aSelector withObject:(id)obj1 withObject:(id)obj2
{
	assert(aSelector);
	if (![self respondsToSelector:aSelector])
	{
		[self doesNotRecognizeSelector:aSelector];
	}
	return (*method_getImplementation(class_getClassMethod(self, aSelector)))(self, aSelector, obj1, obj2);
}

- (void)doesNotRecognizeSelector:(SEL)sel
{
    fprintf(stderr, "-[%s %s]: unrecognized selector sent to instance %p\n", object_getClassName(self), sel_getName(sel), self);
	abort();
}

+ (void)doesNotRecognizeSelector:(SEL)sel
{
    fprintf(stderr, "-[%s %s]: unrecognized selector sent to class\n", object_getClassName(self), sel_getName(sel));
	abort();
}

@end
