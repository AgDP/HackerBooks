//
//  AGTBook.m
//  HackerBooks
//
//  Created by Agustín on 01/04/2015.
//  Copyright (c) 2015 Agustin. All rights reserved.
//

#import "AGTBook.h"
#import "Cons.h"

@implementation AGTBook


-(id) initWithTitulo: (NSString *)titulo
             autores: (NSArray *) autores
                tags: (NSArray *) tags
               image: (UIImage *) image
                 pdf: (NSURL *) pdf
          isFavorite: (BOOL) isFavorite{
    
    if (self = [super init]) {
        _titulo = titulo;
        _autores = autores;
        _tags = tags;
        _image = image;
        _pdf = pdf;
        _isFavorite = isFavorite;
    }
    
    return self;
}


-(NSString *) authorInString{
    
    NSMutableString *cadena = [[NSMutableString alloc] init];
    
    for (int i=0; i < _autores.count; i++) {
        if (i > 0) {
            [cadena appendString:SEPARETE_ARRAY_JSON];
        }
        [cadena appendString:_autores[i]];
        
    }
    
    
    return cadena;
}

-(NSString *) tagsInString{
    
    NSMutableString *cadena = [[NSMutableString alloc] init];
    
    for (int i=0; i < _tags.count; i++) {
        if (i > 0) {
            [cadena appendString:SEPARETE_ARRAY_JSON];
        }
        [cadena appendString:_tags[i]];
        
    }
    
    
    return cadena;
}

@end
