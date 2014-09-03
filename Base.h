#pragma once
#import <CTObject/CTAllocator.h>
#import <stdint.h>
#import <objc/objc.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-root-class"
@interface Base
{
#pragma clang diagnostic pop
	Class isa;
	int64_t retainCount;
	CTAllocator * zone;
}
+ (id)alloc;
+ (id)new;
- (id)init;
- (void)dealloc;
+ (Class)class;
- (Class)class;
+ (Class)superclass;
- (Class)superclass;
- (void)setZone:(CTAllocator *)zone;
- (id)retain;
- (uint64_t)retainCount;
- (void)release;
- (uint8_t)isEqual:(id)object;
+ (uint8_t)isSubclassOfClass:(Class)class;
+ (uint8_t)isKindOfClass:(Class)class;
+ (uint8_t)isMemberOfClass:(Class)class;
- (uint8_t)isSubclassOfClass:(Class)class;
- (uint8_t)isKindOfClass:(Class)class;
- (uint8_t)isMemberOfClass:(Class)class;
- (uint8_t)respondsToSelector:(SEL)aSelector;
@end
