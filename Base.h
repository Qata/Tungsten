#pragma once
#import <CTObject/CTAllocator.h>
#import <stdint.h>
#import <objc/objc.h>

typedef int64_t Integer;
typedef uint64_t UInteger;
enum
{
	UIntegerMax = UINT64_MAX,
	IntegerMax = INT64_MAX
};

enum
{
	NotFound = IntegerMax
};

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-root-class"
@interface Base
{
#pragma clang diagnostic pop
	Class isa;
	Integer retainCount;
	CTAllocator * zone;
}
+ (id)alloc;
+ (id)new;
+ (void)initialize;
- (id)init;
- (void)dealloc;
+ (Class)class;
- (Class)class;
+ (Class)superclass;
- (Class)superclass;
+ (UInteger)hash;
- (UInteger)hash;
- (void)setZone:(CTAllocator *)zone;
- (id)retain;
- (UInteger)retainCount;
- (void)release;
+ (uint8_t)isEqual:(id)object;
- (uint8_t)isEqual:(id)object;
+ (uint8_t)isSubclassOfClass:(Class)class;
- (uint8_t)isSubclassOfClass:(Class)class;
+ (uint8_t)isKindOfClass:(Class)class;
+ (uint8_t)isMemberOfClass:(Class)class;
- (uint8_t)isKindOfClass:(Class)class;
- (uint8_t)isMemberOfClass:(Class)class;
+ (uint8_t)isAncestorOfObject:(id)obj;
+ (uint8_t)respondsToSelector:(SEL)aSelector;
- (uint8_t)respondsToSelector:(SEL)aSelector;
- (id)performSelector:(SEL)aSelector;
+ (id)performSelector:(SEL)aSelector;
- (id)performSelector:(SEL)aSelector withObject:(id)obj;
+ (id)performSelector:(SEL)aSelector withObject:(id)obj;
- (id)performSelector:(SEL)aSelector withObject:(id)obj1 withObject:(id)obj2;
+ (id)performSelector:(SEL)aSelector withObject:(id)obj1 withObject:(id)obj2;
- (void)doesNotRecognizeSelector:(SEL)sel;
@end
