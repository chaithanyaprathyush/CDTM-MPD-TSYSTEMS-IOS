/*
 * (C) Copyright 2011-2013 by Deutsche Telekom AG.
 *
 * This software is property of Deutsche Telekom AG and has
 * been developed for QIVICON platform.
 *
 * See also http://www.qivicon.com
 *
 * DO NOT DISTRIBUTE OR COPY THIS SOFTWARE OR PARTS OF THE SOFTWARE
 * TO UNAUTHORIZED PERSONS OUTSIDE THE DEUTSCHE TELEKOM ORGANIZATION.
 *
 * VIOLATIONS WILL BE PURSUED!
 */

#import <Foundation/Foundation.h>
#import "QCGlobalSettings.h"

@protocol QCHTTPConnectionContext;

/**
 * Abstract base class for all connections.
 * <p>
 * All connections must provide two constructors. The default constructor must
 * create the connection with default connection parameters. The alternative
 * constructor uses {@link QCGlobalSettings} as the only argument, providing the
 * connection parameters within this class.
 *
 */
@interface QCConnection :NSObject

/**
 * Do not call this method. Call initWithConnectionContext: instead 
 */
- (id) init __attribute__((unavailable("Call initWithConnectionContext:")));

/**
 * Initializes a connection with default connection parameters.
 *
 * @param connectionContext
 *            connection context which will be used to establish the connection
 */
- (id) initWithConnectionContext:(id <QCHTTPConnectionContext>)connectionContext;

/**
 * Get the global settings for all subclasses to avoid declaring a protected
 * member.
 *
 * @return global settings
 */
@property (readonly) QCGlobalSettings *globalSettings;

/**
 * Get the connection context for all subclasses to avoid declaring a
 * protected member.
 *
 * @return connection context
 */
@property (readonly) id <QCHTTPConnectionContext> connectionContext;

@end
