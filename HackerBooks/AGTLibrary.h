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

//	Número	total	de	libros
-(NSUInteger)	booksCount;

//	Array	inmutable	(NSArray)	con	todas	las
//	distintas	temáticas	(tags)	en	orden	alfabético.
//	No	puede	bajo	ningún	concepto	haber	ninguna
//	repetida.
-(NSArray*)	tags;

//	Cantidad	de	libros	que	hay	en	una	temática.
//	Si	el	tag	no	existe,	debe	de	devolver	cero
-(NSUInteger)	bookCountForTag:(NSString*)	tag;

//	Array	inmutable	(NSArray)	de	los	libros
//	(instancias	de	AGTBook)	que	hay	en
//	una	temática.
//	Un	libro	puede	estar	en	una	o	más
//	temáticas.	Si	no	hay	libros	para	una
//	temática,	ha	de	devolver	nil.
-(NSArray*)	booksForTag:	(NSString	*)	tag;

//	Un	AGTBook	para	el	libro	que	está	en	la	posición
//	'index'	de	aquellos	bajo	un	cierto
//	tag.	Mira	a	ver	si	puedes	usar	el	método	anterior
//	para	hacer	parte	de	tu	trabajo.
//	Si	el	indice	no	existe	o	el	tag	no	existe,	ha	de	devolver	nil.
-(AGTBook*)	bookForTag:(NSString*)	tag	atIndex:(NSUInteger)	index;

@end
