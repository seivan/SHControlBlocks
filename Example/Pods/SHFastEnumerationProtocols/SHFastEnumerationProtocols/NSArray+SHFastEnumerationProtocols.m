//
//  NSArray+SHFastEnumerationBlocks.m
//  Pods
//
//  Created by Seivan Heidari on 7/15/13.
//
//

#import "NSArray+SHFastEnumerationProtocols.h"

#import "SHCommonEnumerationOperation.h"

@interface NSArray (Private)
-(NSMapTable *)mapTableWith:(NSMapTable *)theMapTable;
@end

@implementation NSArray (SHFastEnumerationProtocols)
@dynamic SH_firstObject;
@dynamic SH_lastObject;
@dynamic SH_toArray;
@dynamic SH_toSet;
@dynamic SH_toOrderedSet;
@dynamic SH_toDictionary;
@dynamic SH_toMapTableWeakToWeak;
@dynamic SH_toMapTableWeakToStrong;
@dynamic SH_toMapTableStrongToStrong;
@dynamic SH_toMapTableStrongToWeak;
@dynamic SH_toHashTableWeak;
@dynamic SH_toHashTableStrong;

#pragma mark - <SHFastEnumerationBlocks>
-(void)SH_each:(SHIteratorBlock)theBlock; { NSParameterAssert(theBlock);
  for (id obj in self) theBlock(obj);
}


-(void)SH_concurrentEach:(SHIteratorBlock)theBlock; { NSParameterAssert(theBlock);

  [self enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, NSUInteger _, BOOL *__) { theBlock(obj); }];
}

-(instancetype)SH_map:(SHIteratorReturnIdBlock)theBlock; { NSParameterAssert(theBlock);
  
  NSMutableArray * map = [NSMutableArray arrayWithCapacity:self.count];
  
  for (id obj in self) {
    id value = theBlock(obj);
    if(value) [map addObject:value];
  }
  return map.copy;
}

-(id)SH_reduceValue:(id)theValue withBlock:(SHIteratorReduceBlock)theBlock; { NSParameterAssert(theBlock);

  id result = theValue;
	for (id obj in self) result = theBlock(result,obj);
	return result;

}

-(id)SH_find:(SHIteratorReturnTruthBlock)theBlock; { NSParameterAssert(theBlock);
  id value = nil;
  
	NSInteger index = [self indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) { return theBlock(obj); }];
	
	if (index != NSNotFound) value = self[index];
	
	return value;

}

-(instancetype)SH_findAll:(SHIteratorReturnTruthBlock)theBlock; { NSParameterAssert(theBlock);
  return [self objectsAtIndexes:
          [self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger _, BOOL *__) {
		return theBlock(obj);
	}]];
}

-(instancetype)SH_reject:(SHIteratorReturnTruthBlock)theBlock; { NSParameterAssert(theBlock);
  return [self SH_findAll:^BOOL(id obj) { return theBlock(obj) == NO; }];
}

-(BOOL)SH_all:(SHIteratorReturnTruthBlock)theBlock; { NSParameterAssert(theBlock);
  return [self SH_findAll:theBlock].count == self.count;
}

-(BOOL)SH_any:(SHIteratorReturnTruthBlock)theBlock; { NSParameterAssert(theBlock);
  return [self SH_find:theBlock] != nil;
}

-(BOOL)SH_none:(SHIteratorReturnTruthBlock)theBlock; { NSParameterAssert(theBlock);
  return [self SH_all:theBlock] == NO;
}

#pragma mark - <SHFastEnumerationProperties>
-(BOOL)SH_isEmpty; {
  return self.count == 0;
}

-(NSArray *)SH_toArray; {
  return self.copy;
}

-(NSSet *)SH_toSet; {
  return [NSSet setWithArray:self];
}

-(NSOrderedSet *)SH_toOrderedSet; {
  return [NSOrderedSet orderedSetWithArray:self];
}

-(NSDictionary *)SH_toDictionary; {
  __block NSInteger counter = -1;
  return [NSDictionary dictionaryWithObjects:self forKeys:[self SH_map:^id(id obj) {
    return @(counter +=1);
  }]];
}

-(NSMapTable *)SH_toMapTableWeakToWeak; {
  NSMapTable * mapTable = [NSMapTable weakToWeakObjectsMapTable];
  return [self mapTableWith:mapTable];
}

-(NSMapTable *)SH_toMapTableWeakToStrong; {
  NSMapTable * mapTable = [NSMapTable weakToStrongObjectsMapTable];
  return [self mapTableWith:mapTable];
}

-(NSMapTable *)SH_toMapTableStrongToStrong; {
  NSMapTable * mapTable = [NSMapTable strongToStrongObjectsMapTable];
  return [self mapTableWith:mapTable];
}

-(NSMapTable *)SH_toMapTableStrongToWeak; {
  NSMapTable * mapTable = [NSMapTable strongToWeakObjectsMapTable];
  return [self mapTableWith:mapTable];
}

-(NSHashTable *)SH_toHashTableWeak; {
  NSHashTable * hashTable = [[NSHashTable alloc] initWithOptions:NSPointerFunctionsStrongMemory capacity:self.count];
  
  [self SH_each:^(id obj) { [hashTable addObject:obj]; }];
  return hashTable;
}

-(NSHashTable *)SH_toHashTableStrong; {
  NSHashTable * hashTable = [NSHashTable weakObjectsHashTable];

  [self SH_each:^(id obj) { [hashTable addObject:obj]; }];
  return hashTable;
}

-(NSDecimalNumber *)SH_collectionAvg; {
  return [SHCommonEnumerationOperation avgForEnumeration:self];
}

-(NSDecimalNumber  *) SH_collectionSum; {
  return [SHCommonEnumerationOperation sumForEnumeration:self];
}

-(id)SH_collectionMax; {
  return [SHCommonEnumerationOperation maxForEnumeration:self];
}

-(id)SH_collectionMin; {
  return [SHCommonEnumerationOperation minForEnumeration:self];
}


#pragma mark - <SHFastEnumerationOrderedBlocks>

-(void)SH_eachWithIndex:(SHIteratorWithIndexBlock)theBlock; { NSParameterAssert(theBlock);
  
  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *_) {
    theBlock(obj,idx);
  }];
}


#pragma mark - <SHFastEnumerationOrderedProperties>
-(id)SH_firstObject; {
  id obj = nil;
  if(self.count > 0) obj = [self objectAtIndex:0];
  return obj;
}

-(id)SH_lastObject; {
  return self.lastObject;
}


#pragma mark - <SHFastEnumerationOrdered>
-(instancetype)SH_reverse; {
  return self.reverseObjectEnumerator.allObjects;
}

@end

@implementation NSMutableArray (SHFastEnumerationProtocols)


#pragma mark - <SHMutableFastEnumerationBlocks>
-(void)SH_modifyMap:(SHIteratorReturnIdBlock)theBlock; { NSParameterAssert(theBlock);
	[self setArray: [self SH_map:theBlock]];
}

-(void)SH_modifyFindAll:(SHIteratorReturnTruthBlock)theBlock; { NSParameterAssert(theBlock);
  [self setArray:[self SH_findAll:theBlock]];
}

-(void)SH_modifyReject:(SHIteratorReturnTruthBlock)theBlock; { NSParameterAssert(theBlock);
  [self setArray:[self SH_reject:theBlock]];
}

#pragma mark - <SHMutableFastEnumerationOrdered>

-(void)SH_modifyReverse; {
  [self setArray:self.reverseObjectEnumerator.allObjects];
}


-(id)SH_popObjectAtIndex:(NSInteger)theIndex; {
  id obj = [self objectAtIndex:theIndex];
  [self removeObjectAtIndex:theIndex];
  return obj;
}

-(id)SH_popFirstObject; {
  id obj = nil;
  if(self.count > 0) obj = [self SH_popObjectAtIndex:0];
  return obj;

}

-(id)SH_popLastObject; {
  id obj = nil;
  NSInteger lastIndex = self.count-1;
  if(lastIndex >= 0) obj = [self SH_popObjectAtIndex:lastIndex];
  return obj;
}


@end

@implementation NSArray (Private)

#pragma mark - Private
-(NSMapTable *)mapTableWith:(NSMapTable *)theMapTable; {
  [self SH_eachWithIndex:^(id obj, NSInteger index) {
    [theMapTable setObject:obj forKey:@(index)];
  }];
  return theMapTable;
}

@end