//
//  AGTLibrary.h
//  HackerBooks
//
//  Created by Agustín on 01/04/2015.
//  Copyright (c) 2015 Agustin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGTBook.h"

@interface AGTLibrary : NSObject

@property (nonatomic, strong) NSMutableDictionary *booksWithTags;
@property (nonatomic, strong) NSMutableDictionary *booksWithFavorites;
@property (nonatomic, strong) NSArray *tagsBooks;
@property (nonatomic, strong) NSMutableArray *favoritesBooks;

-(NSUInteger) favoritesCount;
-(NSUInteger) tagsCount;

-(NSArray *) bookFavoriteAtIndex:(NSString *) index;
-(NSArray *) bookTagAtIndex: (NSString *) index;


@end
