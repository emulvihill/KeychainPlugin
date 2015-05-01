//
//  KeychainAccessor.m
//  KeychainIosExtension
//
//  Created by Richard Lord on 03/05/2012.
//  Copyright (c) 2012 Stick Sports Ltd. All rights reserved.
//

#import "KeychainAccessor.h"

@implementation KeychainAccessor

-(NSMutableDictionary*)queryDictionaryForKey:(NSString*)key
{
    NSMutableDictionary* query = [NSMutableDictionary dictionary];
    
    [query setObject:(__bridge id)kSecClassGenericPassword  forKey:(__bridge id)kSecClass];
    [query setObject:(__bridge id)kSecAttrAccessibleWhenUnlocked forKey:(__bridge id)kSecAttrAccessible];
    [query setObject:key forKey:(__bridge id)kSecAttrService];
    
    return query;
}

-(NSMutableDictionary*)queryDictionaryForKey:(NSString*)key accessGroup:(NSString*)accessGroup
{
    NSMutableDictionary* query = [self queryDictionaryForKey:key];
    [query setObject:accessGroup forKey:(__bridge id)kSecAttrAccessGroup];
    return query;
}

-(OSStatus)insertObject:(NSString*)obj forKey:(NSString*)key
{
    NSMutableDictionary* query = [self queryDictionaryForKey:key];
    
    [query setObject:[obj dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecValueData];
    
    return SecItemAdd ((__bridge CFDictionaryRef) query, NULL);
}

-(OSStatus)updateObject:(NSString*)obj forKey:(NSString*) key
{
    NSMutableDictionary* query = [self queryDictionaryForKey:key];
    
    NSMutableDictionary* change = [NSMutableDictionary dictionary];
    [change setObject:[obj dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id) kSecValueData];
    
    return SecItemUpdate ( (__bridge CFDictionaryRef) query, (__bridge CFDictionaryRef) change);
}

-(OSStatus)insertOrUpdateObject:(NSString*)obj forKey:(NSString*)key
{
    OSStatus status = [self insertObject:obj forKey:key];
    if( status == errSecDuplicateItem )
    {
        status = [self updateObject:obj forKey:key];
    }
    return status;
}

-(NSString*)objectForKey:(NSString*)key
{
    NSMutableDictionary* query = [self queryDictionaryForKey:key];
    [query setObject:(id) kCFBooleanTrue forKey:(__bridge id) kSecReturnData];
    
    NSData* data = nil;
    OSStatus status = SecItemCopyMatching ( (__bridge CFDictionaryRef) query, (void *) &data );
    
    if( status != errSecSuccess || !data )
    {
        return nil;
    }
    
    NSString* value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return value;    
}

-(OSStatus)deleteObjectForKey:(NSString*)key
{
    NSMutableDictionary* query = [self queryDictionaryForKey:key];
    return SecItemDelete( (__bridge CFDictionaryRef) query );
}

-(OSStatus)insertObject:(NSString*)obj forKey:(NSString*)key withAccessGroup:(NSString*)accessGroup
{
    NSMutableDictionary* query = [self queryDictionaryForKey:key accessGroup:accessGroup];
    
    [query setObject:[obj dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecValueData];
    
    return SecItemAdd ((__bridge CFDictionaryRef) query, NULL);
}

-(OSStatus)updateObject:(NSString*)obj forKey:(NSString*)key withAccessGroup:(NSString*)accessGroup
{
    NSMutableDictionary* query = [self queryDictionaryForKey:key accessGroup:accessGroup];
    
    NSMutableDictionary* change = [NSMutableDictionary dictionary];
    [change setObject:[obj dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id) kSecValueData];
    
    return SecItemUpdate ( (__bridge CFDictionaryRef) query, (__bridge CFDictionaryRef) change);
}

-(OSStatus)insertOrUpdateObject:(NSString*)obj forKey:(NSString*)key withAccessGroup:(NSString*)accessGroup
{
    OSStatus status = [self insertObject:obj forKey:key withAccessGroup:accessGroup];
    if( status == errSecDuplicateItem )
    {
        status = [self updateObject:obj forKey:key];
    }
    return status;
}

-(NSString*)objectForKey:(NSString*)key withAccessGroup:(NSString*)accessGroup
{
    NSMutableDictionary* query = [self queryDictionaryForKey:key accessGroup:accessGroup];
    [query setObject:(__bridge id) kCFBooleanTrue forKey:(__bridge id) kSecReturnData];
    
    NSData* data = nil;
    OSStatus status = SecItemCopyMatching ( (__bridge CFDictionaryRef) query, (void *) &data );
    
    if( status != errSecSuccess || !data )
    {
        return nil;
    }
    
    NSString* value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return value;    
}

-(OSStatus)deleteObjectForKey:(NSString*)key withAccessGroup:(NSString*)accessGroup
{
    NSMutableDictionary* query = [self queryDictionaryForKey:key accessGroup:accessGroup];
    return SecItemDelete( (__bridge CFDictionaryRef) query );
}
@end
