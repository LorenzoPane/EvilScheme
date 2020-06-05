#import <Foundation/Foundation.h>

/// @enum URLQueryState
/// @brief Item state if no substitution is found
/// @constant URLQueryStateNull Exclude item
/// @constant URLQueryStatePassThrough Include item and keep value
typedef NS_ENUM(NSInteger, URLQueryState) {
    URLQueryStateNull,
    URLQueryStatePassThrough,
};

/// An object to model translations of query items from one application's context to another's
@interface EVKQueryItemLexicon : NSObject <NSSecureCoding, NSCopying>

/// The name with which to substitute
@property (nonatomic, copy) NSString *param;

/// Dictionary of substitutions for values
@property (nonatomic, copy) NSDictionary<NSString *, NSString *> *substitutions;

/// The default state for values without a substitute
@property URLQueryState defaultState;

/// Creates a new item lexicon with no value modification with a given name
/// @param key The name with which to substitute
+ (instancetype)identityLexiconWithName:(NSString *)key;

/// Initializes a newly created lexicon with the specified key name, dictionary, and default state
/// @param key The name with which to substitute
/// @param dictionary Dictionary of substitutions for values
/// @param state The default state for values without a substitute
- (instancetype)initWithKeyName:(NSString *)key
                     dictionary:(NSDictionary<NSString *, NSString *> *)dictionary
                   defaultState:(URLQueryState)state;

/// Returns a translated query item, or nil if translated item should not be included
/// @param item Item to translate
/// @returns Translated item, or nil if item should not be included
- (NSURLQueryItem *)translateItem:(NSURLQueryItem *)item;

@end
