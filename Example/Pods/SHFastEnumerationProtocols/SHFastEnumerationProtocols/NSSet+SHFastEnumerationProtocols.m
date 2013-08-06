//
//  NSSet+SHFastEnumerationBlocks.m
//  Pods
//
//  Created by Seivan Heidari on 7/15/13.
//
//

#import "NSSet+SHFastEnumerationProtocols.h"

#import "SHCommonEnumerationOperation.h"

@interface NSSet (Private)
-(NSMapTable *)mapTableWith:(NSMapTable *)theMapTable;
@end

@implementation NSSet (SHFastEnumerationProtocols)
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
  [self enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id obj, BOOL *stop) {
    theBlock(obj);
  }];
}

-(instancetype)SH_map:(SHIteratorReturnIdBlock)theBlock; { NSParameterAssert(theBlock);
  NSMutableSet * set = [NSMutableSet setWithCapacity:self.count];
  for (id obj in self) {
    id value = theBlock(obj);
    if(value) [set addObject:value];
  }
  return set.copy;
}

-(id)SH_reduceValue:(id)theValue withBlock:(SHIteratorReduceBlock)theBlock; { NSParameterAssert(theBlock);
  
  id result = theValue;
	for (id obj in self)result = theBlock(result,obj);
	return result;
  
}

-(id)SH_find:(SHIteratorReturnTruthBlock)theBlock; { NSParameterAssert(theBlock);
  id value = nil;
  for (id obj in self) {
    BOOL isPassed = theBlock(obj);
    if(isPassed && value == nil) {
      value = obj;
      break;
    }
  }
  return value;
}

-(instancetype)SH_findAll:(SHIteratorReturnTruthBlock)theBlock; { NSParameterAssert(theBlock);
  NSMutableSet * set = [NSMutableSet setWithCapacity:self.count];
  for (id obj in self) if(theBlock(obj))[set addObject:obj];
  return set.copy;
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
  return self.allObjects;
}

-(NSSet *)SH_toSet; {
  return self.copy;
}

-(NSOrderedSet *)SH_toOrderedSet; {
  return [NSOrderedSet orderedSetWithSet:self];
}

-(NSDictionary *)SH_toDictionary; {
  __block NSInteger counter = -1;
  return [NSDictionary dictionaryWithObjects:self.SH_toArray
                                     forKeys:[self SH_map:^id(id obj) {
    return @(counter +=1);
  }].SH_toArray];
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



@end

@implementation NSMutableSet (SHFastEnumerationProtocols)

#pragma mark - <SHMutableFastEnumerationBlocks>
-(void)SH_modifyMap:(SHIteratorReturnIdBlock)theBlock; { NSParameterAssert(theBlock);
  typeof(self) newSelf = self.copy;
  [self removeAllObjects];
  for(id obj in [newSelf SH_map:theBlock]) [self addObject:obj];
  
  
}

-(void)SH_modifyFindAll:(SHIteratorReturnTruthBlock)theBlock; { NSParameterAssert(theBlock);
  typeof(self) newSelf = self.copy;
  [self removeAllObjects];
  for (id obj in [newSelf SH_findAll:theBlock]) [self addObject:obj];
  
  
  
}

-(void)SH_modifyReject:(SHIteratorReturnTruthBlock)theBlock; { NSParameterAssert(theBlock);
  typeof(self) newSelf = self.copy;
  [self removeAllObjects];
  for (id obj in [newSelf SH_reject:theBlock]) [self addObject:obj];
  
}


@end

@implementation NSSet (Private)

#pragma mark - Private
-(NSMapTable *)mapTableWith:(NSMapTable *)theMapTable; {
  NSInteger index = -1;
  for (id obj in self) [theMapTable setObject:obj forKey:@(index+=1)];
  return theMapTable;
}

@end